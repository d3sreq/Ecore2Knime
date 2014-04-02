package org.myname

import java.util.concurrent.ConcurrentHashMap
import org.eclipse.emf.ecore.EObject

class MyStore {
	val public static map = new ConcurrentHashMap<String, EObject>
}