`ifndef TYPES_SV
`define TYPES_SV

`include "MathTypes.sv"

// 接口设计，封装数据类型，以便更换底层算术类型
`define NUMBER `SINGLE
`define NUMBER_WIDTH `SINGLE_WIDTH


// Systolic Array Definition
`define SYS_ARRAY_LEN 6
typedef struct packed {
    `NUMBER value;
    logic valid;
} Scalar;

function automatic Scalar  _ScalarZero;
    _ScalarZero.value = `NUMBER_WIDTH'b0;
    _ScalarZero.valid = 1'b0;
endfunction

typedef Scalar ScalarArray [`SYS_ARRAY_LEN];
function automatic ScalarArray  _ScalarZeroArray;
    for(int i = 0; i < `SYS_ARRAY_LEN; i++) begin
        _ScalarZeroArray[i] = _ScalarZero();
    end
endfunction

typedef ScalarArray Scalar2DArray [`SYS_ARRAY_LEN];
function automatic Scalar2DArray  _ScalarZero2DArray;
    for(int i = 0; i < `SYS_ARRAY_LEN; i++) begin
        _ScalarZero2DArray[i] = _ScalarZeroArray();
    end
endfunction


// Bus Definition
`define BUS_ARRAY_WIDTH `SYS_ARRAY_LEN 

interface WritePort;
    logic wvalid;
    logic wready;
    `NUMBER wdata [`BUS_ARRAY_WIDTH];

    modport master(
        ouput wavlid,
        input wready,
        output wdata
    );
    modport slave(
        input wvalid,
        output wready,
        input wdata
    );
endinterface

interface ReadPort;
    logic rvalid;
    logic rready;
    `NUMBER rdata [`BUS_ARRAY_WIDTH];

    modport master(
        ouput rvalid,
        input rready,
        input rdata
    );

    modport slave(
        input rvalid,
        output rready,
        ouput rdata
    );

endinterface

`define SLAVE_ADDR `SYS_ARRAY_LEN
`define CORE_NUMBER 8
`define MASTER_ADDR `SLAVE_ADDR+$clog2(`CORE_NUMBER)

`endif