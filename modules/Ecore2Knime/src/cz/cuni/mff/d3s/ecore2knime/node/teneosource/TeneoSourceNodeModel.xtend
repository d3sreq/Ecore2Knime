package cz.cuni.mff.d3s.ecore2knime.node.teneosource

import java.io.File
import java.io.IOException
import org.knime.core.node.CanceledExecutionException
import org.knime.core.node.ExecutionMonitor
import org.knime.core.node.InvalidSettingsException
import org.knime.core.node.NodeModel
import org.knime.core.node.NodeSettingsRO
import org.knime.core.node.NodeSettingsWO
import org.knime.core.node.BufferedDataTable
import org.knime.core.node.ExecutionContext
import org.knime.core.data.DataTableSpec
import org.knime.core.data.DataColumnSpecCreator
import org.knime.core.data.^def.StringCell
import java.io.FileInputStream
import org.knime.core.node.ModelContent
import org.knime.core.node.workflow.NodeContext
import java.io.FileOutputStream

class TeneoSourceNodeModel extends NodeModel {
	
	val static NODE_NUM_UNSET = -1
	
	/**
	 * unique number of the Teneo source node in its workflow
	 */
	private var int nodeNum = NODE_NUM_UNSET
	
	protected new() {
		// no incoming port and one outgoing port
		super(0, 1)
//		println('''new, nodeNum=«nodeNum»''')
	}
	
	override protected BufferedDataTable[] execute(BufferedDataTable[] inData, ExecutionContext exec) throws Exception {
		if (nodeNum == NODE_NUM_UNSET) {
			nodeNum = TeneoSourceIdManager.newNodeNum(workflowName)
		}
		println('''execute, nodeNum=«nodeNum», workflowName=«workflowName»''')
		
		// TODO - just dummy table for now		
		val allColSpecs = #[
			new DataColumnSpecCreator("Column 0", StringCell.TYPE).createSpec
		]
		val outputSpec = new DataTableSpec(allColSpecs)
		val container = exec.createDataContainer(outputSpec)
		container.close
		val out = container.table

		#[out]
	}
	
	/**
     * {@inheritDoc}
     */
	override protected reset() {
		// TODO Code executed on reset.
        // Models build during execute are cleared here.
        // Also data handled in load/saveInternals will be erased here.
        
        nodeNum = NODE_NUM_UNSET
	}
	
	/**
     * {@inheritDoc}
     */
	override protected DataTableSpec[] configure(DataTableSpec[] inSpecs) throws InvalidSettingsException {
		
		// TODO: check if user settings are available, fit to the incoming
        // table structure, and the incoming types are feasible for the node
        // to execute. If the node can execute in its current state return
        // the spec of its output data table(s) (if you can, otherwise an array
        // with null elements), or throw an exception with a useful user message
        
        #[null]
	}
	
	/**
     * {@inheritDoc}
     */
	override protected saveSettingsTo(NodeSettingsWO settings) {
		// TODO save user settings to the config object.		
	}
	
	/**
     * {@inheritDoc}
     */
	override protected loadValidatedSettingsFrom(NodeSettingsRO settings) throws InvalidSettingsException {
		
		// TODO load (valid) settings from the config object.
        // It can be safely assumed that the settings are validated by the 
        // method below.
        
	}
	
	/**
     * {@inheritDoc}
     */
	override protected validateSettings(NodeSettingsRO settings) throws InvalidSettingsException {
		// TODO check if the settings could be applied to our model
        // e.g. if the count is in a certain range (which is ensured by the
        // SettingsModel).
        // Do not actually set any values of any member variables.
	}
	
	val static FILE_NAME = "teneoNodeInternals.xml"
	val static NODE_NUM = "nodeNum"
	
	/**
     * {@inheritDoc}
     */
	override protected loadInternals(File internDir, ExecutionMonitor exec) throws IOException, CanceledExecutionException {
		// TODO load internal data. 
        // Everything handed to output ports is loaded automatically (data
        // returned by the execute method, models loaded in loadModelContent,
        // and user settings set through loadSettingsFrom - is all taken care 
        // of). Load here only the other internals that need to be restored
        // (e.g. data used by the views).
        
        val file = new File(internDir, FILE_NAME)
        val fis = new FileInputStream(file)
        val modelContent = ModelContent.loadFromXML(fis)
        try {
            nodeNum = modelContent.getInt(NODE_NUM)
            TeneoSourceIdManager.register(workflowName, nodeNum)
        } catch (InvalidSettingsException e) {
            throw new IOException(e)
        }
        
//        println('''loadInternals, internDir=«internDir.absolutePath», nodeNum=«nodeNum»''')
	}
	
	def private getWorkflowName() {
		NodeContext.context.workflowManager.name
	}
	
	val static INTERNAL_MODEL = "internalModel"
	
	/**
     * {@inheritDoc}
     */
	override protected saveInternals(File internDir, ExecutionMonitor exec) throws IOException, CanceledExecutionException {
		// TODO save internal models. 
        // Everything written to output ports is saved automatically (data
        // returned by the execute method, models saved in the saveModelContent,
        // and user settings saved through saveSettingsTo - is all taken care 
        // of). Save here only the other internals that need to be preserved
        // (e.g. data used by the views).
        
//        println('''saveInternals, internDir=«internDir.absolutePath», nodeNum=«nodeNum»''')
        
        val modelContent = new ModelContent(INTERNAL_MODEL)
        modelContent.addInt(NODE_NUM, nodeNum)
        
        val file = new File(internDir, FILE_NAME)
        val fos = new FileOutputStream(file)
        modelContent.saveToXML(fos)
	}
	
}