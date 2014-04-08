package my.maxent.predictor

import java.io.File
import java.util.LinkedHashMap
import my.maxent.internal.MaxentPortObject
import my.maxent.internal.MaxentPortObjectSpec
import opennlp.model.MaxentModel
import org.knime.base.data.append.column.AppendedColumnTable
import org.knime.core.data.DataColumnSpecCreator
import org.knime.core.data.DataRow
import org.knime.core.data.DataTableSpec
import org.knime.core.data.RowKey
import org.knime.core.data.container.CellFactory
import org.knime.core.data.container.ColumnRearranger
import org.knime.core.data.^def.StringCell
import org.knime.core.node.BufferedDataTable
import org.knime.core.node.ExecutionContext
import org.knime.core.node.ExecutionMonitor
import org.knime.core.node.NodeLogger
import org.knime.core.node.NodeModel
import org.knime.core.node.NodeSettingsRO
import org.knime.core.node.NodeSettingsWO
import org.knime.core.node.port.PortObject
import org.knime.core.node.port.PortObjectSpec

/**
 * Implementation of MaxentPredictor.
 * This node uses a trained Maximum Entropy model to classify results.
 * 
 * @author Viliam Simko
 */
class MaxentPredictorNodeModel extends NodeModel {
	extension NodeLogger = NodeLogger.getLogger(MaxentPredictorNodeModel)
	
	private static val MODEL_IN_PORT = 0
	private static val DATA_IN_PORT = 1

	new() {
		super(
			#[MaxentPortObject.TYPE, BufferedDataTable.TYPE], // IN PORTS
			#[BufferedDataTable.TYPE] // OUT PORTS
		)
	}
	
	private def <T> T assertType(Object o, Class<T> c) {
		if( ! c.isInstance(o) )
			throw new IllegalArgumentException("Invalid input data")
		return c.cast(o)
	}

	override protected execute(PortObject[] inObjects, ExecutionContext exec) {

		'''Entering execute(inData, exec) of class «class.simpleName»'''.debug
		
		val dataPort = inObjects.get(DATA_IN_PORT).assertType(BufferedDataTable)
		val modelPort = inObjects.get(MODEL_IN_PORT).assertType(MaxentPortObject)
		val maxentModel = modelPort.model.assertType(MaxentModel)
		
		exec.message = "Classifying rows..."
		
		val rearranger = new ColumnRearranger(dataPort.dataTableSpec)
		val columnNames = dataPort.dataTableSpec.columnNames
		val contextColumn = newLinkedHashMap
		columnNames.take(columnNames.length - 1).forEach[name, idx|
			contextColumn.put(name, idx)
		]
		
		rearranger.append(new MaxentPredictorCellFactory(maxentModel, contextColumn))
		val returnVal = exec.createColumnRearrangeTable(dataPort, rearranger, exec)
		
		return #[returnVal]
	}
	
	override protected configure(PortObjectSpec[] inSpecs) {
		
		val dataInSpec = inSpecs.get(DATA_IN_PORT).assertType(DataTableSpec)
		//val modelInSpec = inSpecs.get(MODEL_IN_PORT).assertType(MaxentPortObjectSpec)
		inSpecs.get(MODEL_IN_PORT).assertType(MaxentPortObjectSpec)
		
//        final DataTableSpec trainingSpec =
//            ((MaxentPortObjectSpec)modelObject).getTableSpec();
//        final DataColumnSpec classColumn =
//            ((MaxentPortObjectSpec)modelObject).getClassColumn();
//        if (trainingSpec == null) {
//            throw new InvalidSettingsException("No model spec available");
//        }

        return #[
        	AppendedColumnTable.getTableSpec(
        		dataInSpec, #[
					new DataColumnSpecCreator("Prediction", StringCell.TYPE).createSpec
				]
			)
		]
	}
	
	override protected loadInternals(File nodeInternDir, ExecutionMonitor exec) {}
	override protected saveInternals(File nodeInternDir, ExecutionMonitor exec) {}
	override protected validateSettings(NodeSettingsRO settings) {}
	override protected loadValidatedSettingsFrom(NodeSettingsRO settings) {}
	override protected saveSettingsTo(NodeSettingsWO settings) {}
	override protected reset() {}
}

/**
 * @author Viliam Simko
 */
@Data class MaxentPredictorCellFactory implements CellFactory {
	
	private val MaxentModel maxentModel
	private val LinkedHashMap<String, Integer> contextColumns
	
	override getCells(DataRow row) {
		
		val context = contextColumns.entrySet.map[key + "=" + row.get(value)]
		
		// the classification happens here using the old context
		val outcomeProbs = maxentModel.eval(context)
		val outcome = maxentModel.getBestOutcome(outcomeProbs).replaceAll("^[^=]+=", "")
		
		return #[new StringCell(outcome)]
	}
	
	override getColumnSpecs() {
		return #[new DataColumnSpecCreator("Prediction", StringCell.TYPE).createSpec]
	}
	
	override setProgress(int curRowNr, int rowCount, RowKey lastKey, ExecutionMonitor exec) {}
}