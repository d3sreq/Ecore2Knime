package org.mycounter.support

import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.ocl.OCL
import org.eclipse.ocl.ecore.EcoreEnvironmentFactory
import org.eclipselabs.emodeling.ResourceSetFactory
import java.util.Set

class ExampleComponent {

	ResourceSetFactory resourceSetFactory

	def void bindResourceSetFactory(ResourceSetFactory resourceSetFactory) {
		this.resourceSetFactory = resourceSetFactory
	}

	def void activate() {
		try {
			// load root object from file
			val resSet = new ResourceSetImpl
			
			// load model package from file
			val packageResource = resSet.getResource(URI.createURI("platform:/plugin/org.mycounter/model/My.ecore"), true)
			val packageToRegister = packageResource.contents.head as EPackage
			
			// register package in resource set
			resSet.packageRegistry.put(packageToRegister.nsURI, packageToRegister)
			
			val resource = resSet.getResource(URI.createURI("platform:/plugin/org.mycounter/model/Company.xmi"), true)
	
			var context = resource.contents.head
			
			println('''loaded from file: «context»''')
			
			// save object to mongo DB
			val mongoResourceSet = resourceSetFactory.createResourceSet
			val mongoResource = mongoResourceSet.createResource(URI.createURI("mongodb://localhost/test/My/"))
			mongoResource.contents.add(context)
			mongoResource.save(null)
			
			// load object from mongo DB
			val id = mongoResource.URI.lastSegment
			val resourceSet2 = resourceSetFactory.createResourceSet
			val resource2 = resourceSet2.getResource(URI.createURI("mongodb://localhost/test/My/" + id), true)
			context = resource2.contents.head				
			
			// query model using OCL
			// see org.eclipse.ocl.examples.project.interpreter example plugin and OCLConsolePage.evaluate method
	//		val ocl = OCL.newInstance(new EcoreEnvironmentFactory(
	//				new DelegatingPackageRegistry(context.eResource
	//						.resourceSet.packageRegistry,
	//						EPackage.Registry.INSTANCE)))
	
			val ocl = OCL.newInstance(new EcoreEnvironmentFactory(EPackage.Registry.INSTANCE))
			val helper = ocl.createOCLHelper
	
			val contextClassifier = context.eClass
			helper.context = contextClassifier 
	
			val parsed = helper.createQuery("persons")
			val result = ocl.evaluate(context, parsed) as Set<Object>
			
			println("results of OCL query:")
			result.forEach[println(it)]
		
		} catch (Exception e) {
			println(e)
		}
	} 
}
