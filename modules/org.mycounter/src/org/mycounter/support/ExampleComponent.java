package org.mycounter.support;

import java.io.IOException;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipselabs.emodeling.ResourceSetFactory;

public class ExampleComponent {

	private ResourceSetFactory resourceSetFactory;

	void bindResourceSetFactory(ResourceSetFactory resourceSetFactory) {
		this.resourceSetFactory = resourceSetFactory;
	}
	
	public void activate() throws Exception {

		System.out.println("Starting Mongo EMF example");
		
		ResourceSet resourceSet = resourceSetFactory.createResourceSet();
		
		EPackage libraryPackage = (EPackage)loadEObject("platform:/plugin/org.mycounter/model//extlibrary.ecore");
		
		// TODO - registering to the global registry - probably bad practice but
		// registering to the local ResourceSet registry doesn't work
//		resourceSet.getPackageRegistry().put(libraryPackage.getNsURI(), libraryPackage); 
		EPackage.Registry.INSTANCE.put(libraryPackage.getNsURI(), libraryPackage);
		
		EObject libraryObject = loadEObject("platform:/plugin/org.mycounter/model/Library.xmi");
		
		Resource resource = resourceSet.createResource(URI.createURI("mongodb://localhost/test/Child/"));
		resource.getContents().add(libraryObject);

		try {
			libraryObject.eResource().save(null);
		} catch (IOException e) {
			e.printStackTrace();
		}
		System.out.println(resource.getURI().toString());
		System.out.println(resource.getURIFragment(libraryObject));
		
		String id = resource.getURI().lastSegment();
		System.out.println(id);
		
		ResourceSet resourceSet2 = resourceSetFactory.createResourceSet();
		Resource resource2 = resourceSet2.getResource(URI.createURI("mongodb://localhost/test/Child/" + id), true);
		EObject o = resource2.getContents().get(0);
		System.out.println(o);
		
		for (EObject eo : o.eContents()) {
			System.out.println(eo.toString());
		}
		System.out.println("All done");
		System.out.println(Hello.hello());		
	}

	EObject loadEObject(String fileName) {
		ResourceSet resourceSet = new ResourceSetImpl();
		Resource resource = resourceSet.getResource(URI.createURI(fileName), true);
		EObject toReturn = resource.getContents().get(0);
		return toReturn;
	}
}
