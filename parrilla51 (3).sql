-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 06-11-2025 a las 02:32:28
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
(0, '? Se creó una reserva para el 2025-11-05 a las 2:00pm-4:00pm para 2 personas, ', '2025-11-04 03:17:33', 'reserva'),
(0, 'Nuevo usuario registrado: Wendy (wenda109108@gmail.com)', '2025-11-04 14:58:05', ''),
(0, '? Se creó una reserva para el 2025-11-07 a las 12:30pm-2:30pm para 10 personas, ', '2025-11-04 15:20:38', 'reserva'),
(0, '? Se creó una reserva para el 2025-11-13 a las 12:30pm-2:30pm para 4 personas, ', '2025-11-04 15:38:15', 'reserva'),
(0, '? Se creó una reserva para el 2025-11-14 a las 1:00pm-3:00pm para 3 personas, ', '2025-11-04 15:45:04', 'reserva'),
(0, '❌ Se canceló la reserva N° 5', '2025-11-04 16:00:02', 'reserva'),
(0, '? Se creó una reserva para el 2025-11-13 a las 2:00pm-4:00pm para 5 personas, ', '2025-11-04 16:00:53', 'reserva'),
(0, '❌ Se eliminó el producto \"Pechuga a la plancha\" del inventario', '2025-11-04 17:35:57', 'producto'),
(0, '❌ Se eliminó el producto \"Papas fritasss\" del inventario', '2025-11-04 17:35:57', 'producto'),
(0, '❌ Se eliminó el producto \"Arroz blanco\" del inventario', '2025-11-04 17:35:57', 'producto'),
(0, '? Se creó una reserva para el 2025-11-20 a las 2:00pm-4:00pm para 6 personas, ', '2025-11-05 16:53:05', 'reserva'),
(0, '? Se creó una reserva para el 2025-11-08 a las 12:30pm-2:30pm para 2 personas, ', '2025-11-05 20:17:43', 'reserva');

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

--
-- Volcado de datos para la tabla `detalle_pedido`
--

INSERT INTO `detalle_pedido` (`id_detalle`, `cod_pedido`, `cod_producto`, `cantidad`, `precio_unitario`, `iva`) VALUES
(1, 1, 3, 1, 24000, NULL),
(2, 2, 14, 1, 26000, NULL),
(3, 2, 15, 1, 20000, NULL),
(4, 3, 45, 1, 3500, NULL),
(5, 4, 3, 2, 24000, NULL),
(6, 4, 24, 1, 0, NULL),
(7, 4, 25, 1, 0, NULL),
(8, 5, 47, 1, 4000, NULL);

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
  `cod_usuario` int(11) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pedidos`
--

INSERT INTO `pedidos` (`id_pedido`, `tipo_entrega`, `fecha`, `hora`, `metodo_pago`, `telefono`, `total`, `estado`, `cod_usuario`, `direccion`) VALUES
(1, 'restaurante', '2025-11-05', '15:06:58', 'efectivo', NULL, 24000, 'pendiente', 48, NULL),
(2, 'restaurante', '2025-11-05', '15:27:21', 'efectivo', NULL, 46000, 'pendiente', 48, NULL),
(3, 'domicilio', '2025-11-05', '16:48:00', 'efectivo', 3271738299, 3500, 'pendiente', 48, 'calle 20 # 4-11'),
(4, 'restaurante', '2025-11-05', '16:56:02', 'efectivo', NULL, 48000, 'pendiente', 48, NULL),
(5, 'restaurante', '2025-11-05', '20:18:56', 'efectivo', NULL, 4000, 'pendiente', 48, NULL);

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
(1, 'Churrasco grande (390g)', 40, 'Corte de res a la parrilla', 39000, NULL, NULL, 1, 'churrasco_grandesito.jpg', 'Disponible'),
(2, 'Churrasco pequeño (230g)', 30, 'Corte de res a la parrilla tamaño pequeño', 25000, NULL, NULL, 1, 'churrasco_pequeno.png', 'Disponible'),
(3, 'Carne grande (320g)', 30, 'Carne de res asada a la parrilla', 24000, NULL, NULL, 1, 'carne_grande.jpg', 'Disponible'),
(4, 'Carne pequeña (200g)', 20, 'Carne de res asada tamaño pequeño', 19000, NULL, NULL, 1, 'carne_pequena.jpg', 'Disponible'),
(5, 'Baby beef (250g)', 20, 'Corte fino de res a la parrilla', 32000, NULL, NULL, 1, 'baby_beef.jpg', 'Disponible'),
(6, 'Sobrebarriga dorada a la parrilla o en salsa (270g)', 30, 'Corte de res preparado a la parrilla o en salsa', 26000, NULL, NULL, 1, 'sobrebarriga.jpg', 'Disponible'),
(7, 'Lengua a la parrilla', 30, 'Lengua de res asada a la parrilla', 26000, NULL, NULL, 1, 'lengua_parrilla.jpg', 'Disponible'),
(8, 'Morrillo (290g)', 30, 'Corte de morrillo de res a la parrilla', 26000, NULL, NULL, 1, 'morrillo.jpg', 'Disponible'),
(9, 'Hamburguesa con papa francesa', 30, 'Hamburguesa artesanal acompañada de papas fritas', 16000, NULL, NULL, 1, 'hamburguesa.jpg', 'Disponible'),
(10, 'Churrasco de pollo (pierna pernil deshuesado 280g)', 20, 'Corte delicioso', 19000, NULL, NULL, 2, 'churrasco_pollo.jpg', 'Disponible'),
(11, 'Pechuga grande (320g)', 40, 'Pechuga de pollo asada', 24000, NULL, NULL, 2, 'pechuga_grande.jpg', 'Disponible'),
(12, 'Pechuga pequeña (200g)', 40, 'Pechuga de pollo asada tamaño pequeño', 19000, NULL, NULL, 2, 'pechuga_pequena.jpg', 'Disponible'),
(13, 'Pollo al horno', 20, 'Pollo asado al horno', 16000, NULL, NULL, 2, 'pollo_horno.jpg', 'Disponible'),
(14, 'Lomo de cerdo grande (320g)', 40, 'Lomo de cerdo a la parrilla', 26000, NULL, NULL, 3, 'lomo_cerdo_grande.jpg', 'Disponible'),
(15, 'Lomo de cerdo pequeño (200g)', 40, 'Lomo de cerdo tamaño pequeño', 20000, NULL, NULL, 3, 'lomo_cerdo_pequeno.jpg', 'Disponible'),
(16, 'Costillitas de cerdo (350g)', 50, 'Costillas de cerdo disponibles jueves a domingo', 28000, NULL, NULL, 3, 'costillitas_cerdo.jpg', 'Disponible'),
(17, 'Chorizo', 30, 'Chorizo', 5000, NULL, NULL, 4, 'chorizo.jpg', 'Disponible'),
(18, 'Arepitas de la parrilla', 40, 'Arepas pequeñas a la parrilla', 4000, NULL, NULL, 4, 'arepitas_parrilla.jpg', 'Disponible'),
(19, 'Ajiaco con Pollo (Lunes)', 20, 'Plato típico servido los lunes', 20000, NULL, NULL, 5, 'ajiaco_pollo.jpeg', 'Disponible'),
(20, 'Mondongo (Martes)', 20, 'Plato tradicional servido los martes', 20000, NULL, NULL, 5, 'mondongo.jpg', 'Disponible'),
(21, 'Variado (Miércoles)', 20, 'Plato del día variado servido los miércoles', 20000, NULL, NULL, 5, 'variado.jpg', 'Disponible'),
(22, 'Frijolada (Jueves)', 20, 'Plato típico servido los jueves', 20000, NULL, NULL, 5, 'frijolada.jpg', 'Disponible'),
(23, 'Sancocho Mixto (Viernes)', 20, 'Sancocho de carnes mixtas servido los viernes', 20000, NULL, NULL, 5, 'sancocho_mixto.jpg', 'Disponible'),
(24, 'Papa salada', 50, 'Papa cocida con sal', 0, NULL, NULL, 6, 'papa.jpg', 'Disponible'),
(25, 'Yuca cocida', 20, 'Yuca hervida', 0, NULL, NULL, 6, 'yuca.jpg', 'Disponible'),
(26, 'Aguacate macerado con sal', 200, 'Delicioso aguacate', 0, NULL, NULL, 6, 'aguacate.jpg', 'Disponible'),
(27, 'Arepa de maíz y queso', 30, 'Arepa casera de maíz y queso', 0, NULL, NULL, 6, 'arepitas_parriilla.jpg', 'Disponible'),
(28, 'Ensalada de la casa', 20, 'Mezcla fresca de vegetales', 0, NULL, NULL, 6, 'ensalada.jpg', 'Disponible'),
(29, 'Arroz blanco', 20, 'Arroz blanco tradicional', 0, NULL, NULL, 6, 'arroz.jpg', 'Disponible'),
(30, 'Plato mixto', 30, 'Dos tipos de carne entre pechuga, churrasco y lomo de cerdo', 39000, NULL, NULL, 7, 'plato_mixto.jpg', 'Disponible'),
(31, 'Parrillada (res, cerdo, pechuga y chorizo)', 30, 'Parrillada mixta con carnes variadas', 39000, NULL, NULL, 7, 'parrillada.jpg', 'Disponible'),
(32, 'Medallones de lomo (300g)', 30, 'Corte grueso de lomo de res a la parrilla', 34000, NULL, NULL, 8, 'medallones_lomo.png', 'Disponible'),
(33, 'Biffe chorizo (350g)', 30, 'Corte grueso de biffe chorizo', 34000, NULL, NULL, 8, 'biffe_chorizo.jpg', 'Disponible'),
(34, 'Entrecot', 30, 'Corte de res jugoso a la parrilla', 34000, NULL, NULL, 8, 'entrecot.jpg', 'Disponible'),
(35, 'Gaseosa (350ml)', 60, 'Gaseosa personal 350ml', 3000, NULL, NULL, 9, 'Gaseosa350.jpg', 'Disponible'),
(36, 'Gaseosa (250ml)', 60, 'Gaseosa pequeña 250ml', 2500, NULL, NULL, 9, 'gaseosa250.jpg', 'Disponible'),
(37, 'Cola & Pola', 60, 'Bebida tradicional', 4000, NULL, NULL, 9, 'colaypola.jpg', 'Disponible'),
(38, 'Cerveza Águila o Poker', 60, 'Cerveza nacional Águila o Poker', 4500, NULL, NULL, 9, 'cerveza.jpg', 'Disponible'),
(39, 'Cerveza Club Colombia', 60, 'Cerveza Club Colombia', 6000, NULL, NULL, 9, 'cervezaclub.jpg', 'Disponible'),
(40, 'Agua en botella (600ml)', 60, 'Agua embotellada natural 600ml', 3500, NULL, NULL, 9, 'agua.jpg', 'Disponible'),
(41, 'Agua con gas (600ml)', 60, 'Agua con gas 600ml', 3500, NULL, NULL, 9, 'aguagas.jpg', 'Disponible'),
(42, 'Jugo del día', 60, 'Jugo natural del día', 2500, NULL, NULL, 9, 'jugo.jpg', 'Disponible'),
(43, 'Aguacate', 10, 'Porción de aguacate fresco', 7000, NULL, NULL, 10, 'aguacate.jpg', 'Disponible'),
(44, 'Ensalada (porción)', 20, 'Porción de ensalada fresca', 4000, NULL, NULL, 10, 'ensalada.jpg', 'Disponible'),
(45, 'Arroz blanco', 20, 'Porción de arroz blanco', 3500, NULL, NULL, 10, 'arroz.jpg', 'Disponible'),
(46, 'Papa salada', 50, 'Papa cocida con sal', 3500, NULL, NULL, 10, 'papa.jpg', 'Disponible'),
(47, 'Yuca al vapor', 20, 'Porción de yuca cocida al vapor', 4000, NULL, NULL, 10, 'yuca.jpg', 'Disponible'),
(48, 'Sopa', 40, 'Porción de sopa del día', 5000, NULL, NULL, 10, 'sopa.jpg', 'Disponible');

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
(2, '2025-11-05', '2:00pm-4:00pm', '2', 'confirmada', '3202995114', 44, 'Tommy ', '1111111', 'Almuerzo', ''),
(3, '2025-11-07', '12:30pm-2:30pm', '10', 'Pendiente', '3133443343', 48, 'sofia', '8273627', 'Almuerzo', 'hola'),
(4, '2025-11-13', '12:30pm-2:30pm', '4', 'Pendiente', '3216758943', 48, 'Daniel', '345677', 'Reunión', 'si'),
(6, '2025-11-13', '2:00pm-4:00pm', '5', 'Pendiente', '3176849663', 48, 'Wendy', '1242557', 'Reunión', 'hola'),
(7, '2025-11-20', '2:00pm-4:00pm', '6', 'Pendiente', '3823792393', 48, 'luz ', '19790', 'Almuerzo', 'hola'),
(8, '2025-11-08', '12:30pm-2:30pm', '2', 'Pendiente', '3133443343', 48, 'Wendy', '133567', 'Reunión', 'hola');

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
(45, 'Tommy ', 'V', 3203995114, 'Calle83', 'gisellvega820@gmail.com', 'scrypt:32768:8:1$9yIqNYFkY0T7QZGP$db44251785fa11a7b4fe06402d6d17bcdd6befdf29e4cb8a69d31c742c52ee67dd1966410cf33bba8c5158a639db11c103a53338c702d806743ee727aa84ef82', 'empleado', 'activo', NULL),
(48, 'Wendy', 'Mercado', 3176849663, 'calle 20 # 4-11', 'wenda109108@gmail.com', 'scrypt:32768:8:1$14UwufXojS84lLAC$f311055ac26342cb89f53ab251bdee826cf371c029cd48e7643de508c1f7ed94bbe3b8bf7f534c5ec6205bf569365873e2f3a755590341295b237f814e4b7d2c', 'cliente', 'activo', NULL);

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
-- Indices de la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  ADD PRIMARY KEY (`id_detalle`),
  ADD KEY `fk_detalle_pedido_pedido` (`cod_pedido`),
  ADD KEY `fk_detalle_pedido_producto` (`cod_producto`);

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
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id_pedido`);

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
-- AUTO_INCREMENT de la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

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
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `id_pedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT de la tabla `reservas`
--
ALTER TABLE `reservas`
  MODIFY `id_reserva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  ADD CONSTRAINT `fk_detalle_pedido_pedido` FOREIGN KEY (`cod_pedido`) REFERENCES `pedidos` (`id_pedido`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_detalle_pedido_producto` FOREIGN KEY (`cod_producto`) REFERENCES `productos` (`id_producto`);

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
