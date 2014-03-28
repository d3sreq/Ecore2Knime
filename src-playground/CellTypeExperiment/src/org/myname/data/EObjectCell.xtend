package org.myname.data

import org.knime.core.data.DataCell
import org.knime.core.data.DataValue
import org.eclipse.emf.ecore.EObject

class EObjectCell extends DataCell implements EObjectValue {
	
	override protected equalsDataCell(DataCell dc) {
		if (!(dc instanceof EObjectValue))
			return false
		
		val that = dc as EObjectCell 
		content == that.content
	}
	
	override hashCode() {
		content.hashCode
	}
	
	override toString() {
		content.toString
	}
	
	def static Class<? extends DataValue> getPreferredValueClass() {
		EObjectValue
	}

	val EObject content
	
	new(EObject content) {
		this.content = content
	}
	
	// TODO - implement own serializer, KNIME uses by default java serialization (slow)
//	def static DataCellSerializer<EObjectCell> getCellSerializer() {
//	}
}