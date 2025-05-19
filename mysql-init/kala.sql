Use kala;

DROP TABLE IF EXISTS admin;
DROP TABLE IF EXISTS centro_medico;
DROP TABLE IF EXISTS tipo_documento;
DROP TABLE IF EXISTS contacto_emergencia;
DROP TABLE IF EXISTS medico;
DROP TABLE IF EXISTS paciente;
DROP TABLE IF EXISTS solicitud_centro_medico;
DROP TABLE IF EXISTS tipo_vinculacion;
DROP TABLE IF EXISTS vinculacion;
DROP TABLE IF EXISTS lawton_brody;
DROP TABLE IF EXISTS faq;
DROP TABLE IF EXISTS dad;  
DROP TABLE IF EXISTS uso_cubiertos;
DROP TABLE IF EXISTS metricas_identificacion_dinero;

CREATE TABLE admin (
    pk_id VARCHAR(255) PRIMARY KEY,
    nombre_completo VARCHAR(255)
);

CREATE TABLE centro_medico (
    pk_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255),
    telefono VARCHAR(255),
    direccion VARCHAR(255),
    url_logo VARCHAR(255),
    correo VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE tipo_documento (
    id VARCHAR(50) PRIMARY KEY,
    tipo VARCHAR(100)
);

INSERT IGNORE INTO tipo_documento (id, tipo) VALUES
('CC', 'Cédula de Ciudadanía'),
('TI', 'Tarjeta de Identidad'),
('CE', 'Cédula de Extranjería'),
('PASAPORTE', 'Pasaporte'),
('PEP', 'Permiso Especial de Permanencia');

CREATE TABLE contacto_emergencia (
    pk_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255),
    apellido VARCHAR(255),
    relacion VARCHAR(100),
    direccion VARCHAR(255),
    telefono VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255)
);

CREATE TABLE medico (
    pk_id VARCHAR(255) PRIMARY KEY,
    fk_id_centro_medico BIGINT,
    nombre VARCHAR(255),
    apellido VARCHAR(255),
    fk_id_tipo_documento VARCHAR(50),
    id_documento VARCHAR(100) NOT NULL UNIQUE,
    fecha_nacimiento DATETIME,
    profesion VARCHAR(255),
    especialidad VARCHAR(255),
    telefono VARCHAR(100) NOT NULL UNIQUE,
    direccion VARCHAR(255),
    genero VARCHAR(50),
    tarjeta_profesional VARCHAR(255),
    url_imagen VARCHAR(255),
    correo VARCHAR(255) NOT NULL,

    CONSTRAINT fk_centro_medico FOREIGN KEY (fk_id_centro_medico) REFERENCES centro_medico(pk_id),
    CONSTRAINT fk_tipo_documento FOREIGN KEY (fk_id_tipo_documento) REFERENCES tipo_documento(id)
);

CREATE TABLE paciente (
    pk_id VARCHAR(50) PRIMARY KEY,
    fk_id_centro_medico BIGINT,
    fk_id_tipo_documento VARCHAR(50),
    fk_contacto_emergencia BIGINT NOT NULL,
    nombre VARCHAR(255),
    apellido VARCHAR(255),
    id_documento VARCHAR(100) NOT NULL UNIQUE,
    fecha_nacimiento DATETIME,
    codigo_cie INT,
    telefono VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255),
    direccion VARCHAR(255),
    etapa INT,
    genero VARCHAR(50),
    url_imagen VARCHAR(255),

    CONSTRAINT fk_centro_medico_paciente FOREIGN KEY (fk_id_centro_medico) REFERENCES centro_medico(pk_id),
    CONSTRAINT fk_tipo_documento_paciente FOREIGN KEY (fk_id_tipo_documento) REFERENCES tipo_documento(id),
    CONSTRAINT fk_contacto_emergencia_paciente FOREIGN KEY (fk_contacto_emergencia) REFERENCES contacto_emergencia(pk_id)
);


CREATE TABLE solicitud_centro_medico (
    pk_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255),
    telefono VARCHAR(100),
    direccion VARCHAR(255),
    correo VARCHAR(255),
    url_logo VARCHAR(255),
    estado_solicitud ENUM('PENDIENTE', 'ACEPTADA', 'RECHAZADA') DEFAULT 'PENDIENTE',
    procesado BOOLEAN NOT NULL DEFAULT FALSE
);


CREATE TABLE tipo_vinculacion (
    id VARCHAR(50) PRIMARY KEY,
    tipo VARCHAR(100),
    descripcion VARCHAR(255)
);

INSERT IGNORE INTO tipo_vinculacion (id, tipo, descripcion) VALUES
('TV01', 'MEDICO', 'Vinculación con médico'),
('TV02', 'PACIENTE', 'Vinculación con paciente');


CREATE TABLE vinculacion (
    fk_id_medico VARCHAR(255),
    fk_id_paciente VARCHAR(50),
    fk_id_tipo_vinculacion VARCHAR(50),
    fecha_vinculacion DATETIME,
    
    PRIMARY KEY (fk_id_medico, fk_id_paciente, fk_id_tipo_vinculacion),

    CONSTRAINT fk_medico_vinculacion FOREIGN KEY (fk_id_medico) REFERENCES medico(pk_id),
    CONSTRAINT fk_paciente_vinculacion FOREIGN KEY (fk_id_paciente) REFERENCES paciente(pk_id),
    CONSTRAINT fk_tipo_vinculacion FOREIGN KEY (fk_id_tipo_vinculacion) REFERENCES tipo_vinculacion(id)
);

CREATE TABLE lawton_brody (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    paciente_id VARCHAR(50) NOT NULL,
    medico_id VARCHAR(255) NOT NULL,

    uso_telefono TINYINT COMMENT '0 = No es capaz de usar el teléfono; 1 = Capaz de usar el teléfono',
    hacer_compras TINYINT COMMENT '0 = Dependiente en compras; 1 = Independiente en compras',
    preparacion_comida TINYINT COMMENT '0 = Dependiente en preparación de comida; 1 = Independiente en preparación de comida',
    cuidado_casa TINYINT COMMENT '0 = Dependiente en cuidado de la casa; 1 = Independiente en cuidado de la casa',
    lavado_ropa TINYINT COMMENT '0 = Dependiente en lavado de ropa; 1 = Independiente en lavado de ropa',
    uso_transporte TINYINT COMMENT '0 = Dependiente en uso de transporte; 1 = Independiente en uso de transporte',
    manejo_medicacion TINYINT COMMENT '0 = Dependiente en manejo de medicación; 1 = Independiente en manejo de medicación',
    manejo_finanzas TINYINT COMMENT '0 = Dependiente en manejo de finanzas; 1 = Independiente en manejo de finanzas',

    fecha_registro DATETIME,
    observaciones TEXT,

    FOREIGN KEY (paciente_id) REFERENCES paciente(pk_id),
    FOREIGN KEY (medico_id) REFERENCES medico(pk_id)
);

CREATE TABLE faq (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    paciente_id VARCHAR(50) NOT NULL,
    medico_id VARCHAR(255) NOT NULL,

    manejar_dinero TINYINT COMMENT '0 = independiente; 3 = dependiente',
    hacer_paginas_y_cheques TINYINT COMMENT 'Pagar cuentas / llenar cheques',
    ir_de_compras TINYINT,
    preparar_comidas TINYINT,
    recordar_citas TINYINT,
    usar_telefono TINYINT,
    tomar_medicacion TINYINT,
    manejar_aparatos_electricos TINYINT COMMENT 'Encender TV, radio, microondas',
    desplazarse_fuera_casa TINYINT,
    responder_emergencias TINYINT COMMENT 'Responde con juicio ante emergencias',

    fecha_registro DATETIME,
    observaciones TEXT,

    FOREIGN KEY (paciente_id) REFERENCES paciente(pk_id),
    FOREIGN KEY (medico_id) REFERENCES medico(pk_id)
);

CREATE TABLE dad (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    paciente_id VARCHAR(50) NOT NULL,
    medico_id VARCHAR(255) NOT NULL,

    -- A. Higiene personal
    iniciar_higiene_personal TINYINT,
    planificar_higiene_personal TINYINT,
    ejecutar_higiene_personal TINYINT,

    -- B. Vestirse
    iniciar_vestirse TINYINT,
    planificar_vestirse TINYINT,
    ejecutar_vestirse TINYINT,

    -- C. Alimentación
    iniciar_comer TINYINT,
    planificar_comer TINYINT,
    ejecutar_comer TINYINT,

    -- D. Preparar comidas
    iniciar_preparar_comidas TINYINT,
    planificar_preparar_comidas TINYINT,
    ejecutar_preparar_comidas TINYINT,

    -- E. Tareas domésticas
    iniciar_tareas_domesticas TINYINT,
    planificar_tareas_domesticas TINYINT,
    ejecutar_tareas_domesticas TINYINT,

    -- F. Lavado de ropa
    iniciar_lavar_ropa TINYINT,
    planificar_lavar_ropa TINYINT,
    ejecutar_lavar_ropa TINYINT,

    -- G. Manejo de medicación
    iniciar_medicacion TINYINT,
    planificar_medicacion TINYINT,
    ejecutar_medicacion TINYINT,

    -- H. Manejo de finanzas
    iniciar_manejar_dinero TINYINT,
    planificar_manejar_dinero TINYINT,
    ejecutar_manejar_dinero TINYINT,

    -- I. Seguridad/orientación
    iniciar_orientarse TINYINT,
    planificar_orientarse TINYINT,
    ejecutar_orientarse TINYINT,

    -- Resultado agregado
    porcentaje_independencia DECIMAL(5,2),
    fecha_registro DATETIME,
    observaciones TEXT,

    FOREIGN KEY (paciente_id) REFERENCES paciente(pk_id),
    FOREIGN KEY (medico_id) REFERENCES medico(pk_id)
);

CREATE TABLE uso_cubiertos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id VARCHAR(255) NOT NULL,  
    tiempo DOUBLE PRECISION,            
    puntaje INT,                        
    errores INT,                       
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (paciente_id) REFERENCES paciente(pk_id)
);

CREATE TABLE metricas_identificacion_dinero (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id VARCHAR(50) NOT NULL,
    tiempo_actividad FLOAT,
    errores_totales INT,
    errores_100 INT,
    tiempo_100 FLOAT,
    errores_200 INT,
    tiempo_200 FLOAT,
    errores_500 INT,
    tiempo_500 FLOAT,
    errores_1000 INT,
    tiempo_1000 FLOAT,
    errores_2mil INT,
    tiempo_2mil FLOAT,
    errores_5mil INT,
    tiempo_5mil FLOAT,
    errores_10mil INT,
    tiempo_10mil FLOAT,
    errores_20mil INT,
    tiempo_20mil FLOAT,
    errores_50mil INT,
    tiempo_50mil FLOAT,
    errores_100mil INT,
    tiempo_100mil FLOAT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_paciente_metricas_dinero FOREIGN KEY (paciente_id) REFERENCES paciente(pk_id)
);

CREATE TABLE cajero_actividad (
    user_id VARCHAR(100),
    session_timestamp DATETIME,

    interaction_1_time FLOAT,
    interaction_1_correct_change BOOLEAN,
    interaction_1_delta_change INT,
    interaction_1_identified_well BOOLEAN,

    interaction_2_time FLOAT,
    interaction_2_correct_change BOOLEAN,
    interaction_2_delta_change INT,
    interaction_2_identified_well BOOLEAN,

    interaction_3_time FLOAT,
    interaction_3_correct_change BOOLEAN,
    interaction_3_delta_change INT,
    interaction_3_identified_well BOOLEAN,

    interaction_4_time FLOAT,
    interaction_4_correct_change BOOLEAN,
    interaction_4_delta_change INT,
    interaction_4_identified_well BOOLEAN,

    interaction_5_time FLOAT,
    interaction_5_correct_change BOOLEAN,
    interaction_5_delta_change INT,
    interaction_5_identified_well BOOLEAN
);

CREATE TABLE metricas_mercado (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user VARCHAR(255) NOT NULL,
    totalActivityDuration FLOAT NOT NULL,
    listViewCount INT NOT NULL,
    totalListLookTime FLOAT NOT NULL,
    correctItemsCount INT NOT NULL,
    incorrectItemsCount INT NOT NULL,
    totalQuantityOffBy INT NOT NULL,
    totalIncorrectQuantity INT NOT NULL,
    timestamp DATETIME NOT NULL
);

CREATE TABLE metricas_cubiertos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL,
    tiempo DECIMAL(10,4) NOT NULL,
    puntaje INT NOT NULL,
    errores INT NOT NULL,
    plato_error VARCHAR(100),
    cubierto_dificil VARCHAR(100),

    -- Errores por cubierto
    cuchillo_errores INT DEFAULT 0,
    cuchara_errores INT DEFAULT 0,
    tenedor_errores INT DEFAULT 0,

    -- Errores por plato
    cake_errores INT DEFAULT 0,
    frijoles_errores INT DEFAULT 0,
    hotdog_errores INT DEFAULT 0,
    pizza_errores INT DEFAULT 0,
    salmoncut_errores INT DEFAULT 0,
    sopa_errores INT DEFAULT 0,
    ramen_errores INT DEFAULT 0,

    created_at DATETIME NOT NULL
);

CREATE OR REPLACE VIEW vista_duracion_promedio_mercado AS
SELECT 
    user AS paciente_id,
    ROUND(AVG(totalActivityDuration), 2) AS duracion_promedio
FROM metricas_mercado
GROUP BY user;


CREATE OR REPLACE VIEW vista_consultas_lista_mercado AS
SELECT 
    user AS paciente_id,
    ROUND(AVG(listViewCount), 2) AS promedio_consultas_lista
FROM metricas_mercado
GROUP BY user;

CREATE OR REPLACE VIEW vista_precision_items_mercado AS
SELECT 
    user AS paciente_id,
    SUM(correctItemsCount) AS total_correctos,
    SUM(incorrectItemsCount) AS total_incorrectos
FROM metricas_mercado
GROUP BY user;

CREATE OR REPLACE VIEW vista_errores_cantidad_mercado AS
SELECT 
    user AS paciente_id,
    ROUND(AVG(totalQuantityOffBy), 2) AS promedio_desviacion,
    ROUND(AVG(totalIncorrectQuantity), 2) AS cantidad_incorrecta_prom
FROM metricas_mercado
GROUP BY user;

CREATE OR REPLACE VIEW vista_tiempo_lista_mercado AS
SELECT 
    user AS paciente_id,
    ROUND(AVG(totalListLookTime), 2) AS tiempo_promedio_lista
FROM metricas_mercado
GROUP BY user;

CREATE OR REPLACE VIEW devolucion_cambio AS
SELECT user_id AS paciente_id, 500 AS monto_entregado, interaction_1_correct_change AS correcto
FROM cajero_actividad
UNION ALL
SELECT user_id, 1000, interaction_2_correct_change
FROM cajero_actividad
UNION ALL
SELECT user_id, 2000, interaction_3_correct_change
FROM cajero_actividad
UNION ALL
SELECT user_id, 5000, interaction_4_correct_change
FROM cajero_actividad
UNION ALL
SELECT user_id, 10000, interaction_5_correct_change
FROM cajero_actividad;

CREATE OR REPLACE VIEW vista_tiempos_promedio_ident_moneda AS
SELECT user_id AS paciente_id, 500 AS denominacion, ROUND(AVG(interaction_1_time), 2) AS promedio_tiempo
FROM cajero_actividad
GROUP BY user_id
UNION ALL
SELECT user_id, 1000, ROUND(AVG(interaction_2_time), 2)
FROM cajero_actividad
GROUP BY user_id
UNION ALL
SELECT user_id, 2000, ROUND(AVG(interaction_3_time), 2)
FROM cajero_actividad
GROUP BY user_id
UNION ALL
SELECT user_id, 5000, ROUND(AVG(interaction_4_time), 2)
FROM cajero_actividad
GROUP BY user_id
UNION ALL
SELECT user_id, 10000, ROUND(AVG(interaction_5_time), 2)
FROM cajero_actividad
GROUP BY user_id;

CREATE OR REPLACE VIEW vista_errores_promedio_ident_moneda AS
SELECT user_id AS paciente_id, 500 AS denominacion, ROUND(AVG(ABS(interaction_1_delta_change)), 2) AS promedio_errores
FROM cajero_actividad
GROUP BY user_id
UNION ALL
SELECT user_id, 1000, ROUND(AVG(ABS(interaction_2_delta_change)), 2)
FROM cajero_actividad
GROUP BY user_id
UNION ALL
SELECT user_id, 2000, ROUND(AVG(ABS(interaction_3_delta_change)), 2)
FROM cajero_actividad
GROUP BY user_id
UNION ALL
SELECT user_id, 5000, ROUND(AVG(ABS(interaction_4_delta_change)), 2)
FROM cajero_actividad
GROUP BY user_id
UNION ALL
SELECT user_id, 10000, ROUND(AVG(ABS(interaction_5_delta_change)), 2)
FROM cajero_actividad
GROUP BY user_id;

CREATE OR REPLACE VIEW vista_historial_actividades_mercado AS
SELECT 
  user AS paciente_id,
  DATE(timestamp) AS fecha,
  COUNT(*) AS cantidad
FROM metricas_mercado
GROUP BY user, DATE(timestamp)
ORDER BY fecha;

CREATE OR REPLACE VIEW vista_evolucion_tiempo_mercado AS
SELECT 
  user AS paciente_id,
  timestamp,
  totalActivityDuration AS duracion
FROM metricas_mercado;

CREATE OR REPLACE VIEW vista_precision_sesiones_mercado AS
SELECT 
  user AS paciente_id,
  timestamp,
  correctItemsCount,
  incorrectItemsCount
FROM metricas_mercado;

CREATE OR REPLACE VIEW vista_tiempo_promedio_cubiertos AS
SELECT 
  user_id AS paciente_id,
  DATE(created_at) AS fecha,
  ROUND(AVG(tiempo), 2) AS tiempo_promedio
FROM metricas_cubiertos
GROUP BY user_id, DATE(created_at);

CREATE OR REPLACE VIEW vista_errores_sesion_cubiertos AS
SELECT 
  user_id AS paciente_id,
  DATE(created_at) AS fecha,
  SUM(errores) AS errores_totales
FROM metricas_cubiertos
GROUP BY user_id, DATE(created_at);

CREATE OR REPLACE VIEW vista_errores_por_cubierto AS
SELECT 
  user_id AS paciente_id,
  SUM(cuchillo_errores) AS cuchillo,
  SUM(cuchara_errores) AS cuchara,
  SUM(tenedor_errores) AS tenedor
FROM metricas_cubiertos
GROUP BY user_id;

CREATE OR REPLACE VIEW vista_errores_por_plato AS
SELECT 
  user_id AS paciente_id,
  SUM(cake_errores) AS cake,
  SUM(frijoles_errores) AS frijoles,
  SUM(hotdog_errores) AS hotdog,
  SUM(pizza_errores) AS pizza,
  SUM(salmoncut_errores) AS salmoncut,
  SUM(sopa_errores) AS sopa,
  SUM(ramen_errores) AS ramen
FROM metricas_cubiertos
GROUP BY user_id;

CREATE OR REPLACE VIEW vista_desempeno_cubiertos AS
SELECT 
  user_id AS paciente_id,
  DATE(created_at) AS fecha,
  ROUND(AVG(tiempo), 2) AS tiempo_promedio,
  ROUND(AVG(puntaje), 2) AS puntaje_promedio,
  SUM(errores) AS errores_totales
FROM metricas_cubiertos
GROUP BY user_id, DATE(created_at);