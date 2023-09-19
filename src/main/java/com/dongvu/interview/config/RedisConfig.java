package com.dongvu.interview.config;

import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;

import com.dongvu.interview.model.dto.MenuTreeDTO;

@Configuration
public class RedisConfig {

    @Bean
    public RedisTemplate<String, List<MenuTreeDTO>> redisTemplate(RedisConnectionFactory redisConnectionFactory) {
        RedisTemplate<String, List<MenuTreeDTO>> redisTemplate = new RedisTemplate<>();
        redisTemplate.setConnectionFactory(redisConnectionFactory);
        
        // Sử dụng JsonSerializer (Jackson) cho đối tượng
        RedisSerializer<Object> serializer = new GenericJackson2JsonRedisSerializer();
        redisTemplate.setValueSerializer(serializer);
        redisTemplate.setHashValueSerializer(serializer);
        
        // Sử dụng StringRedisSerializer cho các khóa
        redisTemplate.setKeySerializer(new StringRedisSerializer());
        redisTemplate.setHashKeySerializer(new StringRedisSerializer());
        
        return redisTemplate;
    }
    
    @Bean
    public HashOperations<String, String, List<MenuTreeDTO>> hashOperations(RedisTemplate<String, List<MenuTreeDTO>> redisTemplate) {
        return redisTemplate.opsForHash();
    }
}

