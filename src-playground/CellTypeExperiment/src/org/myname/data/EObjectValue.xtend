package org.myname.data

import javax.swing.Icon
import org.knime.core.data.DataValue
import org.knime.core.data.ExtensibleUtilityFactory
import org.eclipse.emf.ecore.EObject

interface EObjectValue extends DataValue {

	/**
	 * Meta information to this value type.
	 *
	 * @see DataValue#UTILITY
	 */
	val DataValue.UtilityFactory UTILITY = new EObjectUtilityFactory
	
	def EObject getValue()
}

/** Implementations of the meta information of this value class. */
class EObjectUtilityFactory extends ExtensibleUtilityFactory {

	/** Singleton icon to be used to display this cell type. */
	static val ICON = loadIcon(EObjectValue, "/icons/eobjecticon.gif")

	/** Only subclasses are allowed to instantiate this class. */
	protected new() {
		super(EObjectValue)
	}

	/**
	 * {@inheritDoc}
	 */
	override def Icon getIcon() {
		ICON ?: super.icon
	}

	/**
	 * {@inheritDoc}
	 */
	override public String getName() {
		"EObject"
	}
	
}
