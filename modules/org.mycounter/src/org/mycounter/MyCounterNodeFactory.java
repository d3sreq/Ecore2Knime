package org.mycounter;

import org.knime.core.node.NodeDialogPane;
import org.knime.core.node.NodeFactory;
import org.knime.core.node.NodeView;

/**
 * <code>NodeFactory</code> for the "MyCounter" Node.
 * 
 *
 * @author Jiri Vinarek
 */
public class MyCounterNodeFactory 
        extends NodeFactory<MyCounterNodeModel> {

    /**
     * {@inheritDoc}
     */
    @Override
    public MyCounterNodeModel createNodeModel() {
        return new MyCounterNodeModel();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public int getNrNodeViews() {
        return 1;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public NodeView<MyCounterNodeModel> createNodeView(final int viewIndex,
            final MyCounterNodeModel nodeModel) {
        return new MyCounterNodeView(nodeModel);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean hasDialog() {
        return true;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public NodeDialogPane createNodeDialogPane() {
        return new MyCounterNodeDialog();
    }

}

