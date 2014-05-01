package org.mycounter.support

import org.osgi.service.cm.ConfigurationAdmin
import org.eclipselabs.emongo.config.ConfigurationProperties
import java.util.Hashtable
import org.eclipselabs.emongo.MongoClientProvider
import org.eclipselabs.emongo.MongoDatabaseProvider

class ExampleConfigurator {
	ConfigurationAdmin configurationAdmin

	def void bindConfigurationAdmin(ConfigurationAdmin configurationAdmin) {
		this.configurationAdmin = configurationAdmin
	}

	def void activate() {
		val clientConfig = configurationAdmin.createFactoryConfiguration(ConfigurationProperties.CLIENT_PID, null)
		val clientProperties = new Hashtable<String, Object>(#{
			MongoClientProvider.PROP_CLIENT_ID -> "example",
			MongoClientProvider.PROP_URI -> "mongodb://localhost"
		})
		clientConfig.update(clientProperties)

		val dbConfig = configurationAdmin.createFactoryConfiguration(ConfigurationProperties.DATABASE_PID, null)
		val dbProperties = new Hashtable<String, Object>(#{
			MongoDatabaseProvider.PROP_CLIENT_FILTER -> '''(«MongoClientProvider.PROP_CLIENT_ID»=example)''',
			MongoDatabaseProvider.PROP_ALIAS -> "example",
			MongoDatabaseProvider.PROP_DATABASE -> "test"
		})
		dbConfig.update(dbProperties)
	}
	
}