package org.myname.data

import org.knime.core.data.DataCell
import org.knime.core.data.DataValue
import org.eclipse.emf.ecore.EObject
import org.knime.core.data.DataType

class EObjectCell extends DataCell implements EObjectValue {
	
	/**
     * Convenience access member for
     * <code>DataType.getType(EObjectCell.class)</code>.
     *
     * @see DataType#getType(Class)
     */
    public static val DataType TYPE = DataType.getType(typeof(EObjectCell))
	
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
	
	override getValue() {
		return content
	}
	
	// TODO - implement own serializer, KNIME uses by default java serialization (slow)
//	def static DataCellSerializer<EObjectCell> getCellSerializer() {
//	}
}