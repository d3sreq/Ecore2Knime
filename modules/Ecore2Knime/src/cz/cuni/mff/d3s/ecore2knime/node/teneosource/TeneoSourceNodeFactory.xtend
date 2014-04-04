package cz.cuni.mff.d3s.ecore2knime.node.teneosource

import org.knime.core.node.NodeFactory

class TeneoSourceNodeFactory extends NodeFactory<TeneoSourceNodeModel> {
	
	/**
     * {@inheritDoc}
     */
	override createNodeModel() {
		new TeneoSourceNodeModel
	}
	
	/**
     * {@inheritDoc}
     */
	override protected getNrNodeViews() {
		1
	}
	
	/**
     * {@inheritDoc}
     */
	override createNodeView(int viewIndex, TeneoSourceNodeModel nodeModel) {
		new TeneoSourceNodeView(nodeModel)
	}
	
	/**
     * {@inheritDoc}
     */
	override protected hasDialog() {
		true
	}
	
	/**
     * {@inheritDoc}
     */
	override protected createNodeDialogPane() {
		new TeneoSourceNodeDialog
	}
	
}