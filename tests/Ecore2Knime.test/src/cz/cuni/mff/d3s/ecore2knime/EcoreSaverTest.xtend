package cz.cuni.mff.d3s.ecore2knime

import cz.cuni.mff.d3s.ecore2knime.persistence.EcoreSaver
import org.junit.Assert
import org.junit.Test
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import java.util.Properties
import org.hibernate.cfg.Environment
import org.hibernate.dialect.HSQLDialect
import org.eclipse.emf.teneo.PersistenceOptions

class EcoreSaverTest {
	
	val ecoreSaver = new EcoreSaver(new Properties => [
		setProperty(Environment.DRIVER, "org.hsqldb.jdbcDriver")
		setProperty(Environment.USER, "sa")
		setProperty(Environment.URL, "jdbc:hsqldb:hsql://localhost/")
		
		setProperty(Environment.PASS, "")
		setProperty(Environment.DIALECT, typeof(HSQLDialect).getName)
		
		// set a specific option
		// see this page
		// http://wiki.eclipse.org/Teneo/Hibernate/Configuration_Options
		// for all the available options
		setProperty(PersistenceOptions.CASCADE_POLICY_ON_NON_CONTAINMENT, "REFRESH,PERSIST,MERGE")
	], "library")
	
	@Test
	def void loadEPackage() {
		val resourceSet = new ResourceSetImpl
		val pkg = ecoreSaver.loadEObject("data/extlibrary.ecore", resourceSet) as EPackage
		
	    Assert.assertNotNull(pkg)
	}
	
	@Test
	def void loadLibrary() {
		val ecoreResourceSet = new ResourceSetImpl
		val libraryPkg = ecoreSaver.loadEObject("data/extlibrary.ecore", ecoreResourceSet) as EPackage
		
		val libraryResourceSet = new ResourceSetImpl
		
		// TODO - registering to the global registry - probably bad practice but
		// registering to the local ResourceSet registry doesn't work
		// libraryResourceSet.packageRegistry.put(libraryPkg.nsURI, libraryPkg) 
		EPackage.Registry.INSTANCE.put(libraryPkg.nsURI, libraryPkg)

		val lib = ecoreSaver.loadEObject("data/Library.xmi", libraryResourceSet)
	    Assert.assertNotNull(lib)
	}
	
	@Test
	def void saveToDb() {
		val ecoreResourceSet = new ResourceSetImpl
		val libraryPkg = ecoreSaver.loadEObject("data/extlibrary.ecore", ecoreResourceSet) as EPackage
		
		val libraryResourceSet = new ResourceSetImpl
		
		// TODO - registering to the global registry - probably bad practice but
		// registering to the local ResourceSet registry doesn't work
		// libraryResourceSet.packageRegistry.put(libraryPkg.nsURI, libraryPkg) 
		EPackage.Registry.INSTANCE.put(libraryPkg.nsURI, libraryPkg)

		val lib = ecoreSaver.loadEObject("data/Library.xmi", libraryResourceSet)
		
		ecoreSaver.save(#[libraryPkg], #[lib])
		 
	}
}