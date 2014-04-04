package cz.cuni.mff.d3s.ecore2knime.node.teneosource

import org.knime.core.node.NodeView

/**
 * <code>NodeView</code> for the "EcoreSource" Node.
 * Serializes given ecore model to the shared DB
 *
 * @author 
 */
class TeneoSourceNodeView extends NodeView<TeneoSourceNodeModel> {
	
	/**
     * Creates a new view.
     * 
     * @param nodeModel The model (class: {@link EcoreSourceNodeModel})
     */
	protected new(TeneoSourceNodeModel nodeModel) {
		super(nodeModel)

        // TODO instantiate the components of the view here.
	}
	
	/**
     * {@inheritDoc}
     */
	override protected modelChanged() {
		// TODO retrieve the new model from your nodemodel and 
        // update the view.
        val nodeModel = getNodeModel as TeneoSourceNodeModel
        if (nodeModel == null) throw new NullPointerException()        
        
        // be aware of a possibly not executed nodeModel! The data you retrieve
        // from your nodemodel could be null, emtpy, or invalid in any kind.
	}
	
	/**
     * {@inheritDoc}
     */
	override protected onClose() {
		// TODO things to do when closing the view
	}
	
	/**
     * {@inheritDoc}
     */
	override protected onOpen() {
		// TODO things to do when opening the view
	}
	
}