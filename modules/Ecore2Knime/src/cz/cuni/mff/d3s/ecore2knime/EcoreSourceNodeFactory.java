package cz.cuni.mff.d3s.ecore2knime;

import org.knime.core.node.NodeDialogPane;
import org.knime.core.node.NodeFactory;
import org.knime.core.node.NodeView;

/**
 * <code>NodeFactory</code> for the "EcoreSource" Node.
 * Serializes given ecore model to the shared DB
 *
 * @author 
 */
public class EcoreSourceNodeFactory 
        extends NodeFactory<EcoreSourceNodeModel> {

    /**
     * {@inheritDoc}
     */
    @Override
    public EcoreSourceNodeModel createNodeModel() {
        return new EcoreSourceNodeModel();
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
    public NodeView<EcoreSourceNodeModel> createNodeView(final int viewIndex,
            final EcoreSourceNodeModel nodeModel) {
        return new EcoreSourceNodeView(nodeModel);
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
        return new EcoreSourceNodeDialog();
    }

}

