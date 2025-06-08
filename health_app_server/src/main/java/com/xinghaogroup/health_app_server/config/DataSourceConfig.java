package com.xinghaogroup.health_app_server.config;

import com.xinghaogroup.health_app_server.repository.es.UserEsRepository;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.*;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;

@Configuration
@EnableTransactionManagement
@EnableJpaRepositories(
        basePackages = {
                "com.xinghaogroup.health_app_server.repository.jpa",
                "com.xinghaogroup.health_app_server.repository.mysql",
        },
        excludeFilters = @ComponentScan.Filter(
                type = FilterType.ASSIGNABLE_TYPE,
                value = UserEsRepository.class
        )
)
public class DataSourceConfig {

    @Primary
    @Bean
    @ConfigurationProperties("spring.datasource")
    public DataSourceProperties mysqlDataSourceProperties() {
        return new DataSourceProperties();
    }

    @Primary
    @Bean(name = "mysqlDataSource")
    @ConfigurationProperties("spring.datasource.hikari")
    public DataSource mysqlDataSource() {
        return mysqlDataSourceProperties()
                .initializeDataSourceBuilder()
                .type(HikariDataSource.class)
                .build();
    }

    @Primary
    @Bean(name = "entityManagerFactory")
    public LocalContainerEntityManagerFactoryBean mysqlEntityManagerFactory() {
        LocalContainerEntityManagerFactoryBean em = new LocalContainerEntityManagerFactoryBean();
        em.setDataSource(mysqlDataSource());
        em.setPackagesToScan("com.xinghaogroup.health_app_server.entity");
        em.setJpaVendorAdapter(new HibernateJpaVendorAdapter());
        return em;
    }

    @Primary
    @Bean(name = "transactionManager")
    public PlatformTransactionManager mysqlTransactionManager() {
        JpaTransactionManager transactionManager = new JpaTransactionManager();
        transactionManager.setEntityManagerFactory(mysqlEntityManagerFactory().getObject());
        return transactionManager;
    }
}