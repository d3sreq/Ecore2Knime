package my.maxent.internal

import java.io.DataOutputStream
import java.io.IOException
import java.util.zip.ZipEntry
import opennlp.maxent.GISModel
import opennlp.maxent.io.BinaryGISModelWriter
import opennlp.maxent.io.BinaryQNModelWriter
import opennlp.maxent.quasinewton.QNModel
import opennlp.model.AbstractModel
import opennlp.model.BinaryFileDataReader
import opennlp.model.GenericModelReader
import opennlp.model.MaxentModel
import opennlp.perceptron.BinaryPerceptronModelWriter
import opennlp.perceptron.PerceptronModel
import org.knime.core.data.DataColumnSpec
import org.knime.core.data.DataTableSpec
import org.knime.core.node.ExecutionMonitor
import org.knime.core.node.ModelContentRO
import org.knime.core.node.ModelContentWO
import org.knime.core.node.port.AbstractPortObject
import org.knime.core.node.port.AbstractSimplePortObjectSpec
import org.knime.core.node.port.PortObjectSpec
import org.knime.core.node.port.PortObjectZipInputStream
import org.knime.core.node.port.PortObjectZipOutputStream
import org.knime.core.node.port.PortType

class MaxentPortObject extends AbstractPortObject {
	
	public static val TYPE = new PortType(MaxentPortObject)
	static val MAXENT_MODEL_ZIP_ENTRY_NAME = "maxent-model.bin"

	@Property MaxentModel model
	@Property PortObjectSpec spec

	override getSummary() {model.toString}
	override getViews() {null}
	
	/** This constructor is required by the KNIME framework. */
	new() {}
	
	/** This constructor is used for creating a new port */
	new(DataTableSpec trainingDataSpec, MaxentModel model) {
		if (trainingDataSpec == null)
			throw new NullPointerException("trainingDataSpec must not be null")

		if (model == null)
			throw new NullPointerException("model must not be null")
			
		// TODO: the last column is the training column at the moment
		val lastColumnIndex = trainingDataSpec.getNumColumns() - 1
		
		this.model = model
		spec = new MaxentPortObjectSpec(
				trainingDataSpec,
				trainingDataSpec.getColumnSpec(lastColumnIndex)
			)
	}

	override protected load(PortObjectZipInputStream in, PortObjectSpec spec, ExecutionMonitor exec) {
        val entryName = in.nextEntry.name
        if(entryName != MAXENT_MODEL_ZIP_ENTRY_NAME)
        	throw new IOException('''Found unexpected zip entry «entryName»! Expected «MAXENT_MODEL_ZIP_ENTRY_NAME»''')

		val modelReader = new GenericModelReader(new BinaryFileDataReader(in))
		model = modelReader.getModel()
		this.spec = spec
	}
	
	override protected save(PortObjectZipOutputStream out, ExecutionMonitor exec) {
        out.putNextEntry(new ZipEntry(MAXENT_MODEL_ZIP_ENTRY_NAME))
		
		val model = model as AbstractModel
		val outputStream = new DataOutputStream(out)
		
		val modelWriter = switch model {
			GISModel : new BinaryGISModelWriter(model, outputStream)
			QNModel : new BinaryQNModelWriter(model, outputStream)
			PerceptronModel : new BinaryPerceptronModelWriter(model, outputStream)
		}
		
		modelWriter.persist
	}
}

/**
 * The Maxent-specific port object specification implementation.
 * @author Viliam Simko
 */
class MaxentPortObjectSpec extends AbstractSimplePortObjectSpec {

	static val CNFG_CLASS_COL = "classCol"
	static val CNFG_SPEC = "trainingTableSpec"

	@Property DataTableSpec tableSpec		// all columns from training data
	@Property DataColumnSpec classColumn	// outcome column

	/** This constructor is required by the KNIME framework. */
	new() {}

	new(DataTableSpec traingDataSpec, DataColumnSpec classColumn) {
		if (traingDataSpec == null)
			throw new NullPointerException("traingDataSpec must not be null")
			
		if (classColumn == null)
			throw new NullPointerException("classColumn must not be null")

		this.tableSpec = traingDataSpec
		this.classColumn = classColumn
	}
	
	override protected load(ModelContentRO model) {
		val specModel = model.getConfig(CNFG_SPEC)
		tableSpec = DataTableSpec.load(specModel)
		
		val classColModel = model.getModelContent(CNFG_CLASS_COL)
		classColumn = DataColumnSpec.load(classColModel)
	}
	
	override protected save(ModelContentWO model) {
		val specModel = model.addConfig(CNFG_SPEC)
		tableSpec.save(specModel)
		
		val classColModel = model.addModelContent(CNFG_CLASS_COL)
		classColumn.save(classColModel)
	}
}