-- BD TIENDA ON LINE

drop table if exists roles cascade;

create table roles (
    id bigserial constraint pk_roles primary key,
    descripcion varchar(15)
);

insert into roles (descripcion) values ('Administrador'), ('Registrado'), ('Invitado');

drop table if exists usuarios cascade;

create table usuarios (
    id       bigserial   constraint pk_usuarios primary key,
    nick     varchar(15) not null constraint uq_usuarios_nick unique,
    password char(32)    not null constraint ck_password_valida
                         check (length(password) = 32),
    rol_id   bigint      not null constraint fk_usuarios_roles
                         references roles (id) on delete no action
                         on update cascade
);

insert into usuarios (nick, password, rol_id) values ('admin', md5('admin'), 1);
                     (nick, password, rol_id) values ('Pepe', md5('pepe'), 1);
                     (nick, password, rol_id) values ('Invitado', md5(''), 1);

drop table if exists clientes cascade;

create table clientes (
    id            bigserial    constraint pk_clientes primary key,
    codigo        numeric(6)   not null constraint uq_clientes_codigo unique,
    nombre        varchar(15)  not null,
    apellidos     varchar (30) not null,
    dni           varchar(9)   not null constraint uq_clientes_dni unique,
    direccion     varchar(40),
    poblacion     varchar(40),
    codigo_postal char(5)      constraint ck_clientes_codigo_postal
                               check (length(codigo_postal) = 5),
    usuario_id    bigint       constraint fk_clientes_usuarios
                               references usuarios (id)
                               on delete no action on update cascade
);

drop table if exists articulos cascade;

create table articulos (
    id          bigserial constraint pk_articulos primary key,
    codigo      numeric(13) not null constraint uq_articulos_codigo unique,
    descripcion varchar(40),
    precio      numeric (6,2),
    existencias int
);

drop table if exists pedidos cascade;

create table pedidos (
    id           bigint constraint pk_pedidos primary key,
    cliente_id   bigint not null constraint fk_pedidos_clientes
                        references clientes (id)
                        on delete no action on update cascade,
    importe      numeric(8,2),
    gastos_envio numeric(4,2)
);

drop table if exists lineas_pedidos cascade;

create table lineas_pedidos (
    id          bigint       constraint pk_lineas_pedidos primary key,
    pedido_id   bigint       not null constraint fk_lineas_pedidos_pedidos
                             references pedidos (id),
    articulo_id bigint       not null constraint fk_lineas_pedidos_articulos
                             references articulos (id),
    precio      numeric(6,2) not null,
    cantidad    numeric(4,2) not null
);

