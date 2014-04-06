package cz.cuni.mff.d3s.ecore2knime.node.teneosource

import java.util.Map

/**
 * TeneoSourceIdManager provides unique IDs for {@link TeneoSourceNodeModel} and
 * tracks them.
 * Purpose of the TeneoSourceIdManager is to provide unique identification of the
 * Teneo source node which will be persisted between KNIME sessions.
 * Although nodes are uniquely identified by their <code>internDir<code> path 
 * (used in {@link TeneoSourceNodeModel.loadInternals} and 
 * {@link TeneoSourceNodeModel.saveInternals}) this path is not available
 * until user saves the workflow but the identifier is needed in the time
 * of node execution. Therefore the TeneoSourceIdManager provides alternative
 * Teneo source node identification mechanism.
 */
class TeneoSourceIdManager {
	
	private static val Map<String, Integer> nodeCounter = newHashMap
	
	/**
	 * Updates registry with loaded number of the node. Call of this
	 * method is needed when nodes are loaded from the saved workflow
	 * to make sure that new TeneoSource nodes will get unique node numbers
	 * among the workflow.
	 */
	def static synchronized void register(String workflowName, int loadedNodeNum) {
		val lastMaxNum = nodeCounter.get(workflowName) ?: -1
		if (loadedNodeNum > lastMaxNum)
			nodeCounter.put(workflowName, loadedNodeNum)
	}
	
	/**
	 * Generates unique number for the TeneoSource node in the given workflow.
	 */
	def static synchronized int newNodeNum(String workflowName) {
		val lastNum = nodeCounter.get(workflowName) ?: -1
		val newNum = lastNum + 1
		nodeCounter.put(workflowName, newNum)
		newNum 
	}
}