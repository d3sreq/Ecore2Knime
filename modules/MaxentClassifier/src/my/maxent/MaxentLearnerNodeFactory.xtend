package my.maxent

import org.knime.core.node.NodeFactory
import org.knime.core.node.defaultnodesettings.DefaultNodeSettingsPane

/**
 * <code>NodeFactory</code> for the "MaxentLearner" Node.
 * Maximum entropy learner based on OpenNLP implementation
 *
 * @author Viliam Simko
 */
class MaxentLearnerNodeFactory extends NodeFactory<MaxentLearnerNodeModel> {
	override createNodeDialogPane() {new DefaultNodeSettingsPane}
	override createNodeModel() {new MaxentLearnerNodeModel}
	override createNodeView(int viewIndex, MaxentLearnerNodeModel nodeModel) {null}
	override getNrNodeViews() {0}
	override hasDialog() {false}
}