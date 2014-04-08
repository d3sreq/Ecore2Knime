package my.maxent.predictor

import org.knime.core.node.NodeFactory
import org.knime.core.node.defaultnodesettings.DefaultNodeSettingsPane

/**
 * <code>NodeFactory</code> for the "MaxentPredictor" Node.
 * This node uses a trained Maximum Entropy model to classify results
 *
 * @author Viliam Simko
 */
class MaxentPredictorNodeFactory extends NodeFactory<MaxentPredictorNodeModel> {
	override createNodeDialogPane() {new DefaultNodeSettingsPane}
	override createNodeModel() {new MaxentPredictorNodeModel}
	override createNodeView(int viewIndex, MaxentPredictorNodeModel nodeModel) {null}
	override getNrNodeViews() {0}
	override hasDialog() {false}
}