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

class TeneoSourceNodeModel extends NodeModel {
	
	protected new() {
		// no incoming port and one outgoing port
		super(0, 1)		
	}
	
	override protected BufferedDataTable[] execute(BufferedDataTable[] inData, ExecutionContext exec) throws Exception {
		// TODO
		#[]
	}
	
	/**
     * {@inheritDoc}
     */
	override protected reset() {
		// TODO Code executed on reset.
        // Models build during execute are cleared here.
        // Also data handled in load/saveInternals will be erased here.
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
	override protected saveSettingsTo(NodeSettingsWO arg0) {
		// TODO save user settings to the config object.		
	}
	
	/**
     * {@inheritDoc}
     */
	override protected loadValidatedSettingsFrom(NodeSettingsRO settings) throws InvalidSettingsException {
		
		// TODO load (valid) settings from the config object.
        // It can be safely assumed that the settings are valided by the 
        // method below.
        
	}
	
	override protected validateSettings(NodeSettingsRO settings) throws InvalidSettingsException {
		// TODO check if the settings could be applied to our model
        // e.g. if the count is in a certain range (which is ensured by the
        // SettingsModel).
        // Do not actually set any values of any member variables.
	}
	
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
	}
	
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
	}
	
}