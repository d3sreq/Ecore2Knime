package org.mycounter;

import org.knime.core.node.defaultnodesettings.DefaultNodeSettingsPane;
import org.knime.core.node.defaultnodesettings.DialogComponentNumber;
import org.knime.core.node.defaultnodesettings.SettingsModelIntegerBounded;

/**
 * <code>NodeDialog</code> for the "MyCounter" Node.
 * 
 *
 * This node dialog derives from {@link DefaultNodeSettingsPane} which allows
 * creation of a simple dialog with standard components. If you need a more 
 * complex dialog please derive directly from 
 * {@link org.knime.core.node.NodeDialogPane}.
 * 
 * @author Jiri Vinarek
 */
public class MyCounterNodeDialog extends DefaultNodeSettingsPane {

    /**
     * New pane for configuring MyCounter node dialog.
     * This is just a suggestion to demonstrate possible default dialog
     * components.
     */
    protected MyCounterNodeDialog() {
        super();
        
        addDialogComponent(new DialogComponentNumber(
                new SettingsModelIntegerBounded(
                    MyCounterNodeModel.CFGKEY_COUNT,
                    MyCounterNodeModel.DEFAULT_COUNT,
                    Integer.MIN_VALUE, Integer.MAX_VALUE),
                    "Counter:", /*step*/ 1, /*componentwidth*/ 5));
                    
    }
}

