/* @(#)$RCSfile$ 
 * $Revision$ $Date$ $Author$
 *
 */
package org.mycounter;

import org.eclipse.core.runtime.Plugin;
import org.osgi.framework.BundleContext;

/**
 * This is the eclipse bundle activator.
 * Note: KNIME node developers probably won't have to do anything in here, 
 * as this class is only needed by the eclipse platform/plugin mechanism.
 * If you want to move/rename this file, make sure to change the plugin.xml
 * file in the project root directory accordingly.
 *
 * @author Jiri Vinarek
 */
public class MyCounterNodePlugin extends Plugin {
    // The shared instance.
    private static MyCounterNodePlugin plugin;

	/**
     * The constructor.
     */
    public MyCounterNodePlugin() {
        super();
        plugin = this;
    }
    
    /**
     * This method is called when the plug-in is stopped.
     * 
     * @param context The OSGI bundle context
     * @throws Exception If this plugin could not be stopped
     */
    @Override
    public void stop(final BundleContext context) throws Exception {
        super.stop(context);
        plugin = null;
    }

    /**
     * Returns the shared instance.
     * 
     * @return Singleton instance of the Plugin
     */
    public static MyCounterNodePlugin getDefault() {
        return plugin;
    }

}

