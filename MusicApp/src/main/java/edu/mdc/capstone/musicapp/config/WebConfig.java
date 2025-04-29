package edu.mdc.capstone.musicapp.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.*;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    /**
     * Disable Boot's "catch-all" static mapping so that
     * /dashboard/{userId} (and /{userId}) go to your controllers,
     * not to a ResourceHttpRequestHandler.
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry
            .addResourceHandler("/CSS/**")
            .addResourceLocations("classpath:/static/CSS/");
        registry
            .addResourceHandler("/JS/**")
            .addResourceLocations("classpath:/static/JS/");
        registry
            .addResourceHandler("/IMGS/**")
            .addResourceLocations("classpath:/static/IMGS/");
        // if you use webjars:
        registry
            .addResourceHandler("/webjars/**")
            .addResourceLocations("classpath:/META-INF/resources/webjars/");
    }
}