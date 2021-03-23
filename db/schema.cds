using {
    cuid,
    managed
} from '@sap/cds/common';

namespace integradorSchema;

type tv_nombre : String;

type estados : String enum {
    activo;
    baja;
    pendiente
};

aspect logueo : {
    @mandatory nombreUsuario : tv_nombre;
    @mandatory contrasenia   : String;
}

aspect Usuarios : logueo {
    @mandatory email : array of String;
    puntos           : Integer;
    estado           : estados
}

// Libros con varios autores
entity Libros : cuid, managed {
    @mandatory nombre    : tv_nombre;
    fechaPublicacion     : Date;
    @mandatory editorial : Association to one Editoriales;
    @mandatory autor     : Association to one Autores;
    @mandatory puntaje   : Integer;
    criticas             : array of String(500);
    clientesVendidos     : Association to many Clientes_libros
                               on clientesVendidos.libro = $self;
}

entity Autores : cuid, managed {
    @mandatory nombre          : tv_nombre;
    genero                     : String default 'novela';
    @mandatory fechaNacimiento : Date;
    nacionalidad               : String;
    cantidadLibros             : Integer;
    ventaDirecta               : Boolean;
    editorial                  : Association to many Editoriales_autores
                                     on editorial.autor = $self;
}

entity Editoriales : cuid, managed {
    nombre       : tv_nombre;
    nacionalidad : String;
    autores      : Association to many Editoriales_autores
                       on autores.editorial = $self;
};


entity Clientes : cuid, managed {
    @mandatory nombre          : tv_nombre;
    @mandatory fechaNacimiento : Date;
    @mandatory DNI             : Integer;
    // librosComprados            : Association to many Libros;
    librosComprados            : Association to many Clientes_libros
                                     on librosComprados.cliente = $self;
    usuario                    : Composition of one Usuarios;
};


entity Editoriales_autores : cuid, managed {
    editorial : Association to Editoriales;
    autor     : Association to Autores;
}

entity Clientes_libros : cuid {
    cliente : Association to Clientes;
    libro   : Association to Libros;
}
