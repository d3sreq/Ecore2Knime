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
		setProperty(Environment.SHOW_SQL, "true")
		setProperty(Environment.USE_SQL_COMMENTS, "true")
		
		setProperty(Environment.PASS, "")
		setProperty(Environment.DIALECT, typeof(HSQLDialect).getName)
		
//		System.setProperty("log4j.appender.stdout", "org.apache.log4j.ConsoleAppender")
//		System.setProperty("log4j.appender.stdout.Target", "System.out")
//		System.setProperty("log4j.appender.stdout.layout", "org.apache.log4j.PatternLayout")
//		System.setProperty("log4j.appender.stdout.layout.ConversionPattern", "%d{ABSOLUTE} %5p %c{1}:%L - %m%n")
		 
//		//# Root logger option
//		System.setProperty("log4j.rootLogger=INFO", "stdout")
//		 
//		//# Hibernate logging options (INFO only shows startup messages)
//		System.setProperty("log4j.logger.org.hibernate", "INFO")
//		 
//		//# Log JDBC bind parameter runtime arguments
//		System.setProperty("log4j.logger.org.hibernate.type", "trace")
		
		
		// set a specific option
		// see this page
		// http://wiki.eclipse.org/Teneo/Hibernate/Configuration_Options
		// for all the available options
		//setProperty(PersistenceOptions.CASCADE_POLICY_ON_NON_CONTAINMENT, "REFRESH,PERSIST,MERGE")
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

		val lib = ecoreSaver.loadEObject("data/Library3.xmi", libraryResourceSet)
		
		ecoreSaver.save(#[libraryPkg], #[lib])
		 
	}
}