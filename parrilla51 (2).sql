-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-11-2025 a las 09:46:35
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `parrilla51`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_historial_pedido` (IN `p_id_pedido` INT, IN `p_estado` VARCHAR(50))   BEGIN
    INSERT INTO historial_pedidos (id_pedido, estado, fecha_cambio)
    VALUES (p_id_pedido, p_estado, NOW());
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alertas`
--

CREATE TABLE `alertas` (
  `id_alerta` int(11) NOT NULL,
  `mensaje` varchar(255) NOT NULL,
  `fecha` datetime NOT NULL,
  `tipo` enum('stock','pedido','reserva','usuario','producto') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `alertas`
--

INSERT INTO `alertas` (`id_alerta`, `mensaje`, `fecha`, `tipo`) VALUES
(1, '👤 Nuevo usuario registrado: Andrés Arias', '2025-09-03 19:07:43', 'usuario'),
(2, '👤 Nuevo usuario registrado: Carlos Ramírez', '2025-09-03 19:07:43', 'usuario'),
(3, '👤 Nuevo usuario registrado: ANDRES ARIAS', '2025-09-03 19:17:39', 'usuario'),
(4, '👤 Nuevo usuario registrado: ANDRES ARIAS', '2025-09-03 19:32:13', 'usuario'),
(5, '📅 Se creó una reserva para el 2025-09-14 a las 18:00:00 en la mesa 1', '2025-09-14 17:36:49', 'reserva'),
(6, '👤 Nuevo usuario registrado: ANDRES ARIAS', '2025-09-14 18:50:59', 'usuario'),
(7, '👤 Nuevo usuario registrado: ANDRES ARIAS', '2025-09-14 18:52:55', 'usuario'),
(8, '👤 Nuevo usuario registrado: ANDRES ARIAS', '2025-09-14 18:56:01', 'usuario'),
(9, '👤 Nuevo usuario registrado: ANDRES ARIAS', '2025-09-14 19:00:49', 'usuario'),
(10, '👤 Nuevo usuario registrado: Carlos Ramírez', '2025-09-14 19:02:31', 'usuario'),
(11, '👤 Nuevo usuario registrado: Carlos Ramírez', '2025-09-15 18:02:09', 'usuario'),
(12, '📅 Se creó una reserva para el 2025-09-18 a las 06:59:00 en la mesa 1', '2025-09-15 18:56:23', 'reserva'),
(13, '👤 Nuevo usuario registrado: ANDRES ARIAS', '2025-09-15 20:12:03', 'usuario'),
(14, '📅 Se creó una reserva para el 2025-09-18 a las 12:35:00 en la mesa 2', '2025-09-15 21:32:39', 'reserva'),
(16, '❌ El pedido N° 1 fue cancelado', '2025-09-15 22:27:32', 'pedido'),
(17, '❌ El pedido N° 2 fue cancelado', '2025-09-16 06:21:53', 'pedido'),
(18, '📅 Se creó una reserva para el 2025-09-19 a las 10:28:00 en la mesa 1', '2025-09-16 06:24:19', 'reserva'),
(19, '📅 Se creó una reserva para el 2025-09-10 a las 09:41:00 en la mesa 2', '2025-09-16 06:39:11', 'reserva'),
(20, '👤 Nuevo usuario registrado: Carlos Ramírez', '2025-09-16 10:22:09', 'usuario'),
(21, '👤 Nuevo usuario registrado: Carlos Ramírez', '2025-09-16 10:23:14', 'usuario'),
(22, '📅 Se creó una reserva para el 2025-09-24 a las 13:52:00 en la mesa 1', '2025-09-16 10:50:31', 'reserva'),
(23, '👤 Nuevo usuario registrado: ANDRES ARIAS', '2025-10-21 14:47:45', 'usuario'),
(24, '👤 Nuevo usuario registrado: ANDRES ARIAS', '2025-10-21 15:03:28', 'usuario'),
(25, '👤 Nuevo usuario registrado: Carlos ARIAS', '2025-10-21 15:46:10', 'usuario'),
(26, '👤 Nuevo usuario registrado: ANDRES ARIAS', '2025-10-28 21:20:47', 'usuario'),
(27, '👤 Nuevo usuario registrado: ANDRES Ramírez', '2025-10-28 21:25:43', 'usuario'),
(28, '👤 Nuevo usuario registrado: ANDRES ARIAS', '2025-10-28 21:49:24', 'usuario'),
(29, '👤 Nuevo usuario registrado: Carlos ARIAS', '2025-10-28 22:17:40', 'usuario'),
(30, '❌ Se eliminó el producto \"pan\" del inventario', '2025-10-28 22:45:02', 'producto'),
(31, '📅 Se creó una reserva para el 2025-10-30 a las 1:30pm-3:30pm para 1 personas, ', '2025-10-28 22:46:57', 'reserva'),
(32, '📅 Se creó una reserva para el 2025-11-11 a las 12:00pm-2:00pm para 1 personas, ', '2025-10-29 22:57:17', 'reserva'),
(33, '👤 Nuevo usuario registrado: Carlos Ramírez', '2025-10-29 23:22:16', 'usuario'),
(34, '👤 Nuevo usuario registrado: Carlos Ramírez', '2025-10-30 19:44:50', 'usuario'),
(35, '👤 Nuevo usuario registrado: dsa asd', '2025-10-30 19:55:26', 'usuario'),
(36, 'Nuevo usuario registrado: ANDRES (andresitoarias96@gmail.com)', '2025-11-01 16:32:03', ''),
(37, 'Nuevo usuario registrado: ANDRES (andresitoarias96@gmail.com)', '2025-11-01 16:32:25', ''),
(38, '📅 Se creó una reserva para el 2025-12-21 a las 12:00pm-2:00pm para 4 personas, ', '2025-11-01 17:01:52', 'reserva'),
(39, 'Nuevo usuario registrado: ANDRES (andresfariasa@juandelcorral.edu.co)', '2025-11-01 21:18:59', ''),
(40, 'Nuevo usuario registrado: dsa (andresfariasa@juandelcorral.edu.co)', '2025-11-01 21:22:05', ''),
(41, 'Nuevo usuario registrado: Carlos (andresfariasa@juandelcorral.edu.co)', '2025-11-01 21:25:40', ''),
(42, '❌ Se eliminó el producto \"Churrasco\" del inventario', '2025-11-01 21:55:31', 'producto'),
(43, 'Nuevo usuario registrado: ANDRES (andresitoarias96@gmail.com)', '2025-11-02 14:49:24', ''),
(44, 'Nuevo usuario registrado: ANDRES (andresitoarias96@gmail.com)', '2025-11-02 15:57:19', ''),
(0, 'Nuevo usuario registrado: Tommy  (gisellvega820@gmail.com)', '2025-11-03 22:23:05', ''),
(0, '❌ Se canceló la reserva N° 3', '2025-11-03 22:58:11', 'reserva'),
(0, '❌ Se canceló la reserva N° 4', '2025-11-03 22:58:11', 'reserva'),
(0, '❌ Se canceló la reserva N° 5', '2025-11-03 22:58:11', 'reserva'),
(0, '❌ Se canceló la reserva N° 6', '2025-11-03 22:58:11', 'reserva'),
(0, '❌ Se canceló la reserva N° 7', '2025-11-03 22:58:11', 'reserva'),
(0, '❌ Se canceló la reserva N° 8', '2025-11-03 22:58:11', 'reserva'),
(0, '❌ Se canceló la reserva N° 9', '2025-11-03 22:58:11', 'reserva'),
(0, '❌ Se canceló la reserva N° 10', '2025-11-03 22:58:11', 'reserva'),
(0, '❌ Se canceló la reserva N° 11', '2025-11-03 22:58:11', 'reserva'),
(0, '? Se creó una reserva para el 2025-11-04 a las  para 10 personas, ', '2025-11-04 02:17:22', 'reserva'),
(0, '? Se creó una reserva para el 2025-11-05 a las 2:00pm-4:00pm para 2 personas, ', '2025-11-04 03:17:33', 'reserva');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id_categoria` int(11) NOT NULL,
  `nombre_categoria` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id_categoria`, `nombre_categoria`) VALUES
(1, 'Res'),
(2, 'Pollo'),
(3, 'Cerdo'),
(4, 'Entradas'),
(5, 'Plato del día'),
(6, 'Acompañamientos'),
(7, 'Platos Combinados'),
(8, 'Cortes gruesos'),
(9, 'Bebidas'),
(10, 'Adicionales');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_pedido`
--

CREATE TABLE `detalle_pedido` (
  `id_detalle` int(11) NOT NULL,
  `cod_pedido` int(11) DEFAULT NULL,
  `cod_producto` int(11) DEFAULT NULL,
  `cantidad` bigint(20) DEFAULT NULL,
  `precio_unitario` bigint(20) DEFAULT NULL,
  `iva` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_pedido_restaurante`
--

CREATE TABLE `detalle_pedido_restaurante` (
  `id_detalle_pedido_restaurante` int(11) NOT NULL,
  `id_pago_restaurante` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle_pedido_restaurante`
--

INSERT INTO `detalle_pedido_restaurante` (`id_detalle_pedido_restaurante`, `id_pago_restaurante`, `id_producto`, `cantidad`, `precio_unitario`) VALUES
(1, 1, 2, 1, 24000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `domicilios`
--

CREATE TABLE `domicilios` (
  `id_domicilio` int(11) NOT NULL,
  `cod_pedido` int(11) DEFAULT NULL,
  `cod_usuario` int(11) DEFAULT NULL,
  `cod_direccion` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_pedidos`
--

CREATE TABLE `historial_pedidos` (
  `id_historial` int(11) NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `estado` enum('pendiente','en preparacion','entregado','cancelado') NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `fecha_cambio` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `insumos`
--

CREATE TABLE `insumos` (
  `id_insumo` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 0,
  `precio` decimal(10,2) NOT NULL DEFAULT 0.00,
  `fecha_vencimiento` date DEFAULT NULL,
  `lote` varchar(50) DEFAULT NULL,
  `subcategoria_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `insumos`
--

INSERT INTO `insumos` (`id_insumo`, `nombre`, `cantidad`, `precio`, `fecha_vencimiento`, `lote`, `subcategoria_id`) VALUES
(2, 'tomate', 12, 1200.00, '2025-10-04', '2025-09-08', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mesas`
--

CREATE TABLE `mesas` (
  `id_mesa` int(11) NOT NULL,
  `numero_mesa` int(11) NOT NULL,
  `capacidad` int(11) NOT NULL,
  `ubicacion` varchar(100) DEFAULT NULL,
  `estado` enum('ocupada','libre') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `mesas`
--

INSERT INTO `mesas` (`id_mesa`, `numero_mesa`, `capacidad`, `ubicacion`, `estado`) VALUES
(1, 1, 0, NULL, 'libre'),
(2, 2, 0, NULL, 'libre'),
(3, 3, 0, NULL, 'libre'),
(4, 4, 0, NULL, 'libre'),
(5, 5, 0, NULL, 'libre'),
(6, 6, 0, NULL, 'libre'),
(7, 7, 0, NULL, 'libre'),
(8, 8, 0, NULL, 'libre'),
(9, 9, 0, NULL, 'libre'),
(10, 10, 0, NULL, 'libre'),
(11, 11, 0, NULL, 'libre'),
(12, 12, 0, NULL, 'libre'),
(13, 13, 0, NULL, 'libre'),
(14, 14, 0, NULL, 'libre'),
(15, 15, 0, NULL, 'libre'),
(16, 16, 0, NULL, 'libre'),
(17, 17, 0, NULL, 'libre'),
(18, 18, 0, NULL, 'libre'),
(19, 19, 0, NULL, 'libre'),
(20, 20, 0, NULL, 'libre');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos_restaurante`
--

CREATE TABLE `pagos_restaurante` (
  `id_pago_restaurante` int(11) NOT NULL,
  `id_mesa` int(11) DEFAULT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `total` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pagos_restaurante`
--

INSERT INTO `pagos_restaurante` (`id_pago_restaurante`, `id_mesa`, `fecha`, `hora`, `total`) VALUES
(1, 1, '2025-11-04', '01:17:05', 24000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `id_pedido` int(11) NOT NULL,
  `tipo_entrega` enum('restaurante','domicilio') DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` time DEFAULT NULL,
  `metodo_pago` varchar(50) DEFAULT NULL,
  `telefono` bigint(20) DEFAULT NULL,
  `total` bigint(20) DEFAULT NULL,
  `estado` enum('entregado','cancelado','pendiente','en preparacion') DEFAULT 'pendiente',
  `cod_mesa` int(11) DEFAULT NULL,
  `cod_usuario` int(11) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `pedidos`
--
DELIMITER $$
CREATE TRIGGER `trg_alerta_pedido_cancelado` AFTER UPDATE ON `pedidos` FOR EACH ROW BEGIN
    IF NEW.estado = 'cancelado' AND OLD.estado <> 'cancelado' THEN
        INSERT INTO alertas(mensaje, fecha, tipo)
        VALUES (CONCAT('❌ El pedido N° ', NEW.id_pedido, ' fue cancelado'), NOW(), 'pedido');
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_alerta_pedido_confirmado` AFTER UPDATE ON `pedidos` FOR EACH ROW BEGIN
    IF NEW.estado = 'confirmado' AND OLD.estado <> 'confirmado' THEN
        INSERT INTO alertas(mensaje, fecha, tipo)
        VALUES (CONCAT('✅ El pedido N° ', NEW.id_pedido, ' fue confirmado'), NOW(), 'pedido');
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_pedidos_historial` AFTER UPDATE ON `pedidos` FOR EACH ROW BEGIN
    IF NEW.estado <> OLD.estado THEN
        CALL registrar_historial_pedido(NEW.id_pedido, NEW.estado);
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido_mesa`
--

CREATE TABLE `pedido_mesa` (
  `cod_pedido` int(11) NOT NULL,
  `cod_mesa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_producto` int(11) NOT NULL,
  `nombre` varchar(60) DEFAULT NULL,
  `cantidad` bigint(20) DEFAULT NULL,
  `descripcion` varchar(150) DEFAULT NULL,
  `precio` bigint(20) DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `fecha_lote` date DEFAULT NULL,
  `cod_categoria` int(11) DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `estado` enum('Disponible','No disponible') NOT NULL DEFAULT 'Disponible'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `nombre`, `cantidad`, `descripcion`, `precio`, `fecha_vencimiento`, `fecha_lote`, `cod_categoria`, `imagen`, `estado`) VALUES
(2, 'Pechuga a la plancha', 20, 'Pechuga de pollo dorada', 24000, NULL, NULL, 2, 'pechuga.jpg', 'Disponible'),
(3, 'Papas fritasss', 30, 'Porción de papas fritas doradas', 8000, NULL, NULL, 6, 'https://www.google.com/imgres?q=papas%20fritas&imgurl=https%3A%2F%2Fcocina-casera.com%2Fwp-content%2Fuploads%2F2023%2F01%2Fpatatas-fritas-crujientes-francesa-1.jpg&imgrefurl=https%3A%2F%2Fcocina-casera.com%2Fpatatas-fritas-crujientes-a-la-francesa%2F&doci', 'Disponible'),
(4, 'Arroz blanco', 25, 'Porción de arroz blanco cocido', 6000, NULL, NULL, 6, 'arroz.jpg', 'Disponible');

--
-- Disparadores `productos`
--
DELIMITER $$
CREATE TRIGGER `trg_alerta_producto_eliminado` AFTER DELETE ON `productos` FOR EACH ROW BEGIN
    INSERT INTO alertas(mensaje, fecha, tipo)
    VALUES (CONCAT('❌ Se eliminó el producto "', OLD.nombre, '" del inventario'), NOW(), 'producto');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_alerta_stock_bajo` AFTER UPDATE ON `productos` FOR EACH ROW BEGIN
    IF NEW.cantidad < 5 AND OLD.cantidad >= 5 THEN
        INSERT INTO alertas(mensaje, fecha, tipo)
        VALUES (CONCAT('⚠ El producto "', NEW.nombre, '" tiene stock bajo: ', NEW.cantidad), NOW(), 'stock');
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_alerta_stock_recuperado` AFTER UPDATE ON `productos` FOR EACH ROW BEGIN
    IF NEW.cantidad >= 5 AND OLD.cantidad < 5 THEN
        INSERT INTO alertas(mensaje, fecha, tipo)
        VALUES (CONCAT('✅ El producto "', NEW.nombre, '" se recuperó, stock actual: ', NEW.cantidad), NOW(), 'stock');
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reservas`
--

CREATE TABLE `reservas` (
  `id_reserva` int(11) NOT NULL,
  `fecha` date DEFAULT NULL,
  `hora` enum('','11:30m-1:30pm','12:00pm-2:00pm','12:30pm-2:30pm','1:00pm-3:00pm','1:30pm-3:30pm','2:00pm-4:00pm','2:30pm-4:30pm') NOT NULL,
  `cant_personas` enum('','1','2','3','4','5','6','7','8','9','10','11','12') DEFAULT NULL,
  `estado` enum('Pendiente','confirmada','Completada') DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `documento` varchar(50) DEFAULT NULL,
  `tipo_evento` enum('','Almuerzo','Reunión','Celebración','Otro') DEFAULT NULL,
  `comentarios` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `reservas`
--

INSERT INTO `reservas` (`id_reserva`, `fecha`, `hora`, `cant_personas`, `estado`, `telefono`, `id_usuario`, `nombre`, `documento`, `tipo_evento`, `comentarios`) VALUES
(1, '2025-11-04', '', '10', 'Completada', '3202995114', 45, 'Tommy ', '1141118769', 'Almuerzo', 'holaa'),
(2, '2025-11-05', '2:00pm-4:00pm', '2', 'confirmada', '3202995114', 44, 'Tommy ', '1111111', 'Almuerzo', '');

--
-- Disparadores `reservas`
--
DELIMITER $$
CREATE TRIGGER `trg_alerta_reserva_cancelada` AFTER DELETE ON `reservas` FOR EACH ROW BEGIN
    INSERT INTO alertas(mensaje, fecha, tipo)
    VALUES (
        CONCAT('❌ Se canceló la reserva N° ', OLD.id_reserva),
        NOW(),
        'reserva'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_alerta_reserva_creada` AFTER INSERT ON `reservas` FOR EACH ROW BEGIN
    INSERT INTO alertas(mensaje, fecha, tipo)
    VALUES (
        CONCAT('? Se creó una reserva para el ', NEW.fecha, ' a las ', NEW.hora, 
               ' para ', NEW.cant_personas, ' personas, '),
        NOW(),
        'reserva'
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `salida`
--

CREATE TABLE `salida` (
  `id_salida` int(11) NOT NULL,
  `fecha` date DEFAULT NULL,
  `cantidad` bigint(20) DEFAULT NULL,
  `cod_producto` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subcategorias_insumos`
--

CREATE TABLE `subcategorias_insumos` (
  `id_subcategoria` int(11) NOT NULL,
  `nombre_subcategoria` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `subcategorias_insumos`
--

INSERT INTO `subcategorias_insumos` (`id_subcategoria`, `nombre_subcategoria`) VALUES
(1, 'Verduras frescas'),
(2, 'Carnes y proteínas');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `apellido` varchar(100) DEFAULT NULL,
  `telefono` bigint(20) DEFAULT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `contraseña` varchar(255) DEFAULT NULL,
  `rol` enum('cliente','empleado','administrador') DEFAULT 'cliente',
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  `token_activacion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `apellido`, `telefono`, `direccion`, `correo`, `contraseña`, `rol`, `estado`, `token_activacion`) VALUES
(41, 'Carlos', 'ARIAS', 3227288957, 'Calle 50 #10-20', 'andresfariasa@juandelcorral.edu.co', 'scrypt:32768:8:1$YSRmC1o4NPXHpv7H$348bfc74f22207a360287f557e089860aeaad6bf0ef467898e51924005cec898d69fb00e089c208f80f00b9306c2c30b596ac407b99f70e00ce93135bc571f3c', 'administrador', 'activo', NULL),
(44, 'ANDRES', 'ARIAS', 3227288957, '23123213', 'andresitoarias96@gmail.com', 'scrypt:32768:8:1$klKZyuqIwyWus5G0$e025b24bdba0c53be4d1223f2180805c898c507b940f96a3723acf73615c8b4e00559a614d9705647888c19e46c4ebe1be2167c090febb318c6076eed57f5bfa', 'administrador', 'activo', NULL),
(45, 'Tommy ', 'V', 3203995114, 'Calle83', 'gisellvega820@gmail.com', 'scrypt:32768:8:1$9yIqNYFkY0T7QZGP$db44251785fa11a7b4fe06402d6d17bcdd6befdf29e4cb8a69d31c742c52ee67dd1966410cf33bba8c5158a639db11c103a53338c702d806743ee727aa84ef82', 'empleado', 'activo', NULL);

--
-- Disparadores `usuarios`
--
DELIMITER $$
CREATE TRIGGER `trg_alerta_usuario_desactivado` AFTER UPDATE ON `usuarios` FOR EACH ROW BEGIN
    IF NEW.estado = 'inactivo' AND OLD.estado <> 'inactivo' THEN
        INSERT INTO alertas(mensaje, fecha, tipo)
        VALUES (CONCAT('? El usuario "', OLD.nombre, ' ', OLD.apellido, '" fue desactivado'), NOW(), 'usuario');
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_alerta_usuario_registrado` AFTER INSERT ON `usuarios` FOR EACH ROW BEGIN
    INSERT INTO alertas (mensaje, fecha, tipo)
    VALUES (
        CONCAT('Nuevo usuario registrado: ', NEW.nombre, ' (', NEW.correo, ')'),
        NOW(),
        'registro'
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_alertas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_alertas` (
`id_alerta` int(11)
,`mensaje` varchar(255)
,`fecha` datetime
,`tipo` enum('stock','pedido','reserva','usuario','producto')
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_detalle_pedidos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_detalle_pedidos` (
`id_detalle` int(11)
,`id_pedido` int(11)
,`fecha` date
,`hora` time
,`producto` varchar(60)
,`cantidad` bigint(20)
,`precio_unitario` bigint(20)
,`subtotal` bigint(39)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_historial_pedidos`
--

CREATE TABLE `vista_historial_pedidos` (
  `id_historial` int(11) DEFAULT NULL,
  `id_pedido` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` time DEFAULT NULL,
  `nombre_usuario` varchar(100) DEFAULT NULL,
  `apellido_usuario` varchar(100) DEFAULT NULL,
  `estado` enum('pendiente','en preparacion','entregado','cancelado') DEFAULT NULL,
  `fecha_estado` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_pedidos_usuarios`
--

CREATE TABLE `vista_pedidos_usuarios` (
  `id_pedido` int(11) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `apellido` varchar(100) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` time DEFAULT NULL,
  `total` bigint(20) DEFAULT NULL,
  `estado` enum('entregado','cancelado','pendiente','en preparacion') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_productos_categorias`
--

CREATE TABLE `vista_productos_categorias` (
  `id_producto` int(11) DEFAULT NULL,
  `nombre` varchar(60) DEFAULT NULL,
  `precio` bigint(20) DEFAULT NULL,
  `cantidad` bigint(20) DEFAULT NULL,
  `nombre_categoria` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_reservas_mesas`
--

CREATE TABLE `vista_reservas_mesas` (
  `id_reserva` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` enum('','11:30m-1:30pm','12:00pm-2:00pm','12:30pm-2:30pm','1:00pm-3:00pm','1:30pm-3:30pm','2:00pm-4:00pm','2:30pm-4:30pm') DEFAULT NULL,
  `cant_personas` enum('','1','2','3','4','5','6','7','8','9','10','11','12') DEFAULT NULL,
  `estado` enum('Pendiente','confirmada','Completada') DEFAULT NULL,
  `id_mesa` int(11) DEFAULT NULL,
  `capacidad` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_stock_bajo`
--

CREATE TABLE `vista_stock_bajo` (
  `id_producto` int(11) DEFAULT NULL,
  `nombre` varchar(60) DEFAULT NULL,
  `cantidad` bigint(20) DEFAULT NULL,
  `precio` bigint(20) DEFAULT NULL,
  `estado_stock` varchar(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_total_pagos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_total_pagos` (
`id_pago_restaurante` int(11)
,`id_mesa` int(11)
,`fecha` date
,`hora` time
,`total_registrado` decimal(10,2)
,`total_calculado` decimal(42,2)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_alertas`
--
DROP TABLE IF EXISTS `vista_alertas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_alertas`  AS SELECT `alertas`.`id_alerta` AS `id_alerta`, `alertas`.`mensaje` AS `mensaje`, `alertas`.`fecha` AS `fecha`, `alertas`.`tipo` AS `tipo` FROM `alertas` ORDER BY `alertas`.`fecha` DESC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_detalle_pedidos`
--
DROP TABLE IF EXISTS `vista_detalle_pedidos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_detalle_pedidos`  AS SELECT `dp`.`id_detalle` AS `id_detalle`, `dp`.`cod_pedido` AS `id_pedido`, `p`.`fecha` AS `fecha`, `p`.`hora` AS `hora`, `pr`.`nombre` AS `producto`, `dp`.`cantidad` AS `cantidad`, `dp`.`precio_unitario` AS `precio_unitario`, `dp`.`cantidad`* `dp`.`precio_unitario` AS `subtotal` FROM ((`detalle_pedido` `dp` join `pedidos` `p` on(`dp`.`cod_pedido` = `p`.`id_pedido`)) join `productos` `pr` on(`dp`.`cod_producto` = `pr`.`id_producto`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_total_pagos`
--
DROP TABLE IF EXISTS `vista_total_pagos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_total_pagos`  AS SELECT `p`.`id_pago_restaurante` AS `id_pago_restaurante`, `p`.`id_mesa` AS `id_mesa`, `p`.`fecha` AS `fecha`, `p`.`hora` AS `hora`, `p`.`total` AS `total_registrado`, coalesce(sum(`d`.`cantidad` * `d`.`precio_unitario`),0) AS `total_calculado` FROM (`pagos_restaurante` `p` left join `detalle_pedido_restaurante` `d` on(`p`.`id_pago_restaurante` = `d`.`id_pago_restaurante`)) GROUP BY `p`.`id_pago_restaurante`, `p`.`id_mesa`, `p`.`fecha`, `p`.`hora`, `p`.`total` ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id_categoria`);

--
-- Indices de la tabla `detalle_pedido_restaurante`
--
ALTER TABLE `detalle_pedido_restaurante`
  ADD PRIMARY KEY (`id_detalle_pedido_restaurante`),
  ADD KEY `id_pago_restaurante` (`id_pago_restaurante`),
  ADD KEY `fk_detalle_producto` (`id_producto`);

--
-- Indices de la tabla `mesas`
--
ALTER TABLE `mesas`
  ADD PRIMARY KEY (`id_mesa`);

--
-- Indices de la tabla `pagos_restaurante`
--
ALTER TABLE `pagos_restaurante`
  ADD PRIMARY KEY (`id_pago_restaurante`),
  ADD KEY `fk_pagos_mesa` (`id_mesa`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id_producto`),
  ADD KEY `fk_categoria_productos` (`cod_categoria`);

--
-- Indices de la tabla `reservas`
--
ALTER TABLE `reservas`
  ADD PRIMARY KEY (`id_reserva`),
  ADD KEY `fk_reservas_usuarios` (`id_usuario`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `detalle_pedido_restaurante`
--
ALTER TABLE `detalle_pedido_restaurante`
  MODIFY `id_detalle_pedido_restaurante` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `mesas`
--
ALTER TABLE `mesas`
  MODIFY `id_mesa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `pagos_restaurante`
--
ALTER TABLE `pagos_restaurante`
  MODIFY `id_pago_restaurante` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `reservas`
--
ALTER TABLE `reservas`
  MODIFY `id_reserva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalle_pedido_restaurante`
--
ALTER TABLE `detalle_pedido_restaurante`
  ADD CONSTRAINT `detalle_pedido_restaurante_ibfk_1` FOREIGN KEY (`id_pago_restaurante`) REFERENCES `pagos_restaurante` (`id_pago_restaurante`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detalle_producto` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `pagos_restaurante`
--
ALTER TABLE `pagos_restaurante`
  ADD CONSTRAINT `fk_pagos_mesa` FOREIGN KEY (`id_mesa`) REFERENCES `mesas` (`id_mesa`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `fk_categoria_productos` FOREIGN KEY (`cod_categoria`) REFERENCES `categorias` (`id_categoria`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `reservas`
--
ALTER TABLE `reservas`
  ADD CONSTRAINT `fk_reservas_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
