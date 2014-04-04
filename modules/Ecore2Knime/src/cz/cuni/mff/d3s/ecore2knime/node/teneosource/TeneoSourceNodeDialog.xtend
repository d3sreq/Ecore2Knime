package cz.cuni.mff.d3s.ecore2knime.node.teneosource

import org.knime.core.node.defaultnodesettings.DefaultNodeSettingsPane

/**
 * <code>NodeDialog</code> for the "TeneoSource" Node.
 * Creates new connection to the shared DB.
 *
 * This node dialog derives from {@link DefaultNodeSettingsPane} which allows
 * creation of a simple dialog with standard components. If you need a more 
 * complex dialog please derive directly from 
 * {@link org.knime.core.node.NodeDialogPane}.
 * 
 * @author 
 */
class TeneoSourceNodeDialog extends DefaultNodeSettingsPane {
	
	/**
     * New pane for configuring TeneoSource node dialog.
     */
	protected new() {
		// TODO - add GUI for connection string addition. 
	}
}