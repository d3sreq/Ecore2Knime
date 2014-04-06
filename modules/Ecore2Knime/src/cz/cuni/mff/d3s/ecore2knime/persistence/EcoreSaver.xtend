//package cz.cuni.mff.d3s.ecore2knime.persistence
//
//import java.util.Properties
//import org.eclipse.emf.common.util.URI
//import org.eclipse.emf.ecore.EObject
//import org.eclipse.emf.ecore.EPackage
//import org.eclipse.emf.ecore.resource.Resource
//import org.eclipse.emf.ecore.resource.ResourceSet
//import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
//import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
//import org.eclipse.emf.teneo.hibernate.HbDataStore
//import org.eclipse.emf.teneo.hibernate.HbHelper
//
//class EcoreSaver {
//	// nacist metamodel z .ecore
//	// nacist model z .xmi
//	
//	val Properties properties
//	val String sessionFactoryName
//	
//	def private void initRegistry() {
//		// Register the XMI resource factory for any extension
//	    val reg = Resource.Factory.Registry.INSTANCE
//	    val m = reg.getExtensionToFactoryMap
//	    m.put("*", new XMIResourceFactoryImpl)
//	}
//	
//	def EObject loadEObject(String fileLocation, ResourceSet resourceSet) {
//		initRegistry
//	    
//	    // Obtain a new resource set
//    	val resSet = new ResourceSetImpl
//
//	    // Get the resource
//    	val resource = resSet.getResource(URI.createURI(fileLocation), true)
//	    
//	    // Get the first model element = EPackage
//	    resource.getContents.head as EObject
//	}
//	
//	new(Properties properties, String sessionFactoryName) {
//		this.properties = properties
//		this.sessionFactoryName = sessionFactoryName
//	}
//	
//	def void save(EPackage[] packages, Iterable<EObject> toSerialize) {
//
//		// create the HbDataStore using the name
//		val HbDataStore hbds = HbHelper.INSTANCE.createRegisterDataStore(sessionFactoryName)
//
//		// set the properties
//		hbds.setDataStoreProperties(properties)
//
//		// sets its epackages stored in this datastore
//		hbds.setEPackages(packages)
//
//		// initialize, also creates the database tables
//		hbds.initialize
//		
//		val sessionFactory = hbds.sessionFactory
//
//		// Create a session and a transaction
//		val session = sessionFactory.openSession
//		val tx = session.getTransaction
//
//		// Start a transaction, create a model and make it persistent
//		tx.begin
//		
//		// TODO - serialize model objects
//		// session.save()
//		toSerialize.forEach[
//			session.save(it)
//		]
//		
//		// at commit the objects will be present in the database
//		tx.commit
//		
//		// and close of, this should actually be done in a finally block - TODO
//		session.close
//	}
//	
//	
//}