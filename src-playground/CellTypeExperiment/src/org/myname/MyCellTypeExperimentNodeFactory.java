package org.myname;

import org.knime.core.node.NodeDialogPane;
import org.knime.core.node.NodeFactory;
import org.knime.core.node.NodeView;

/**
 * <code>NodeFactory</code> for the "MyCellTypeExperiment" Node.
 * 
 *
 * @author Jiri Vinarek
 */
public class MyCellTypeExperimentNodeFactory 
        extends NodeFactory<MyCellTypeExperimentNodeModel> {

    /**
     * {@inheritDoc}
     */
    @Override
    public MyCellTypeExperimentNodeModel createNodeModel() {
        return new MyCellTypeExperimentNodeModel();
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
    public NodeView<MyCellTypeExperimentNodeModel> createNodeView(final int viewIndex,
            final MyCellTypeExperimentNodeModel nodeModel) {
        return new MyCellTypeExperimentNodeView(nodeModel);
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
        return new MyCellTypeExperimentNodeDialog();
    }

}

