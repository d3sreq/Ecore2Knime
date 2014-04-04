package cz.cuni.mff.d3s.ecore2knime

import org.eclipse.core.runtime.Plugin
import org.osgi.framework.BundleContext

/**
 * This is the eclipse bundle activator.
 * Note: KNIME node developers probably won't have to do anything in here, 
 * as this class is only needed by the eclipse platform/plugin mechanism.
 * If you want to move/rename this file, make sure to change the plugin.xml
 * file in the project root directory accordingly.
 *
 * @author 
 */
class Ecore2KnimePlugin extends Plugin {
	
	// The shared instance.
    var static Ecore2KnimePlugin plugin

    /**
     * The constructor.
     */
    new() {    
        plugin = this
    }

    /**
     * This method is called upon plug-in activation.
     * 
     * @param context The OSGI bundle context
     * @throws Exception If this plugin could not be started
     */
    override start(BundleContext context) throws Exception {
        super.start(context)
    }

    /**
     * This method is called when the plug-in is stopped.
     * 
     * @param context The OSGI bundle context
     * @throws Exception If this plugin could not be stopped
     */
    override stop(BundleContext context) throws Exception {
        super.stop(context)
        plugin = null
    }

    /**
     * Returns the shared instance.
     * 
     * @return Singleton instance of the Plugin
     */
    def static Ecore2KnimePlugin getDefault() {
        plugin
    }
}