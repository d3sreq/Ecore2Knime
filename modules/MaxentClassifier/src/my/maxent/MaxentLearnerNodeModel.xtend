package my.maxent

import java.io.File
import my.maxent.internal.DataTableEventStream
import my.maxent.internal.KnimeProgressDataIndexer
import my.maxent.internal.MaxentPortObject
import my.maxent.internal.MaxentPortObjectSpec
import opennlp.maxent.GIS
import opennlp.maxent.quasinewton.QNTrainer
import opennlp.model.DataIndexer
import opennlp.perceptron.PerceptronTrainer
import org.knime.core.data.DataTableSpec
import org.knime.core.node.BufferedDataTable
import org.knime.core.node.ExecutionContext
import org.knime.core.node.ExecutionMonitor
import org.knime.core.node.InvalidSettingsException
import org.knime.core.node.NodeLogger
import org.knime.core.node.NodeModel
import org.knime.core.node.NodeSettingsRO
import org.knime.core.node.NodeSettingsWO
import org.knime.core.node.port.PortObject
import org.knime.core.node.port.PortObjectSpec

/**
 * This is the model implementation of MaxentLearner.
 * Maximum entropy learner based on OpenNLP implementation
 * 
 * @author Viliam Simko
 */
class MaxentLearnerNodeModel extends NodeModel {
	
	extension NodeLogger = NodeLogger.getLogger(MaxentLearnerNodeModel)
	
	private static val TRAINING_DATA_PORT = 0
	private static val MAXENT_TRAIN_METHOD = "GIS"
	private static val GIS_CUTOFF = 5
	private static val GIS_NUM_ITERATIONS = 100
	private static val GIS_USE_SMOOTHING = true
	private static val PERCEPTRON_USE_SKIP_AVERAGING = true
	private static val PERCEPTRON_NUM_ITERATIONS = 100
	private static val QN_NUM_UPDATES = 7
	private static val QN_MAX_FCT_EVAL = 300
	
	protected new() {
		super(
			#[ BufferedDataTable.TYPE ],	// IN PORTS
			#[ MaxentPortObject.TYPE ]		// OUT PORTS
		) 
	}
	
	/** Here we specify input and output ports */
	override protected configure(PortObjectSpec[] inSpecs) {

		val inSpec = inSpecs.get(TRAINING_DATA_PORT)
		
		if (! (inSpec instanceof DataTableSpec) )
			throw new IllegalArgumentException("Invalid input data")

		val tableSpec = inSpec as DataTableSpec

		val lastColumnIdx = tableSpec.getNumColumns() - 1
		val classColumn = tableSpec.getColumnSpec(lastColumnIdx).name

		if (tableSpec.findColumnIndex(classColumn) < 0)
			throw new InvalidSettingsException("Please define the classification column")

		if (tableSpec.getNumColumns() < 2)
			throw new InvalidSettingsException("Input table should contain at least 2 columns")

		return #[new MaxentPortObjectSpec(tableSpec, tableSpec.getColumnSpec(classColumn))]
	}
	
	/** Here we train the Maxent model */
	override protected execute(PortObject[] inObjects, ExecutionContext exec) {
		'''Entering execute of «this.class.name»'''.debug

		// check input data
		if(inObjects == null || inObjects.length != 1)
			throw new IllegalArgumentException('''Invalid data on input port «TRAINING_DATA_PORT»''')
			
		val inObject = inObjects.get(TRAINING_DATA_PORT)

		val trainingTable = switch inObject {
			BufferedDataTable : inObject
			default: throw new IllegalArgumentException('''Invalid data on input port «TRAINING_DATA_PORT»''')
		}

		"Training a MaxEnt model ...".debug

		val dataIndexer = new KnimeProgressDataIndexer(
				exec.createSubProgress(0.2), // exec monitor
				new DataTableEventStream(trainingTable), // event stream
				GIS_CUTOFF, //cutoff
				true // sort
			)
		
		exec.message = "Training..."
		
		val trainedMaxentModel = switch MAXENT_TRAIN_METHOD {
			case "QN":			trainUsingQuasiNewton(dataIndexer)
			case "GIS":			trainUsingGIS(dataIndexer)
			case "PERCEPTRON":	trainUsingPerceptron(dataIndexer)
			default:			throw new IllegalArgumentException("Unsupported training method")
		}

		exec.message = "Training done."

		return #[new MaxentPortObject(trainingTable.dataTableSpec, trainedMaxentModel)]		
	}
	
	/**
	 * We need this hack because OpenNLP implementation
	 * uses a hard-coded private field.
	 */
	private def hackOpenNLP(PerceptronTrainer trainerInstance) {
		try {
			PerceptronTrainer.getDeclaredField("printMessages") => [
				accessible = true
				setBoolean(trainerInstance, false)
				accessible = false
			]
		} catch (Exception e) {
			e.message.error
		} 
	}
	
	/**
	 * Maxent model trained using Perceptron algorithm
	 */
	private def trainUsingPerceptron(DataIndexer dataIndexer) {
		val trainer = new PerceptronTrainer => [
			hackOpenNLP
			skippedAveraging = PERCEPTRON_USE_SKIP_AVERAGING
			stepSizeDecrease = 0
			tolerance = PerceptronTrainer.TOLERANCE_DEFAULT
		]
		
		return trainer.trainModel(
			PERCEPTRON_NUM_ITERATIONS,
			dataIndexer,
			GIS_CUTOFF,
			PERCEPTRON_USE_SKIP_AVERAGING
		)
	}

	/**
	 * Maxent model trained using the Quasi-Newton method
	 */
	private def trainUsingQuasiNewton(DataIndexer dataIndexer) {
		val trainer = new QNTrainer(QN_NUM_UPDATES, QN_MAX_FCT_EVAL, false)
		return trainer.trainModel(dataIndexer)
	}

	/**
	 * Maxent model trained using the Generalized Iterative Scaling
	 * NOTE: GISTrainer is not publicly accessible, we had to use GIS class instead.
	 */
	private def trainUsingGIS(DataIndexer indexer) {
		return GIS.trainModel(
			GIS_NUM_ITERATIONS,	// number of iterations
			indexer,			// indexer
			false,				// print messages to stdout (hard-coded in opennlp implementation)
			GIS_USE_SMOOTHING,	// smoothing
			null,				// prior
			GIS_CUTOFF			// cutoff
		);
	}

	override protected loadInternals(File nodeInternDir, ExecutionMonitor exec) {}
	override protected saveInternals(File nodeInternDir, ExecutionMonitor exec) {}
	override protected saveSettingsTo(NodeSettingsWO settings) {}
	override protected validateSettings(NodeSettingsRO settings) {}
	override protected loadValidatedSettingsFrom(NodeSettingsRO settings) {}
	override protected reset() {}
}