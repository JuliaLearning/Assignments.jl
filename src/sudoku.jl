using JuMP
using Cbc
using Test

export sudoku_model
export sudoku_fix_cells
export sudoku_table
export test_sudoku_model

const I = 1:9
const J = 1:9
const K = 1:9

function sudoku_model()
    model = Model()
    @variable(model, x[I, J, K], Bin)
    # --- Student's task ---
    # TODO: Implement constraints

    # TODO: implement objective function

    # --- end of task ---
    return model
end

function sudoku_fix_cells(model, fixed::Array{NTuple{3, Int}})
    x = model[:x]
    @constraint(model, [(i, j, k) in fixed], x[i, j, k] == 1)
end

function sudoku_table(model)
    x_value = value.(model[:x])
    return [findmax(collect(x_value[i, j, :]))[2] for i in I, j in J]
end

function test_sudoku_model()
    @info "Creating the sudoku model"
    model = sudoku_model()
    sudoku_fix_cells(model, [
        (1,2,6), (1,4,1), (1,6,4), (1,8,5), (2,3,8), (2,4,3), (2,6,5), (2,7,6),
        (3,1,2), (3,7,7), (4,1,8), (4,4,4), (4,6,7), (4,9,6), (5,3,6), (5,7,3),
        (6,1,7), (6,4,9), (6,6,1), (6,9,4), (7,1,5), (7,9,2), (8,3,7), (8,4,2),
        (8,6,6), (8,7,9), (9,2,4), (9,4,5), (9,6,8), (9,8,7)
    ])

    @info "Solving the sudoku"
    optimizer = optimizer_with_attributes(Cbc.Optimizer, "logLevel" => 0)
    set_optimizer(model, optimizer)
    optimize!(model)

    answer = sudoku_table(model)
    solution = [9 6 3 1 7 4 2 5 8;
                1 7 8 3 2 5 6 4 9;
                2 5 4 6 8 9 7 3 1;
                8 2 1 4 3 7 5 9 6;
                4 9 6 8 5 2 3 1 7;
                7 3 5 9 6 1 8 2 4;
                5 8 9 7 1 3 4 6 2;
                3 1 7 2 4 6 9 8 5;
                6 4 2 5 9 8 1 7 3]
    @info "Printing the result"
    @info answer
    @test answer == solution
end
