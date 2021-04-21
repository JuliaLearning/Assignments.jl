using LinearAlgebra
using ForwardDiff
using Test

export newton_raphson
export test_newton_raphson

∇(f, x) = ForwardDiff.jacobian(f, x)

function newton_raphson(f::Function, x0::Vector{Float64}, ϵ::Float64)
    xs = [x0]
    d = inv(-∇(f, x0)) * f(x0)
    while norm(d) > ϵ
        x = xs[end] + d
        d = inv(-∇(f, x)) * f(x)
        push!(xs, x)
    end
    return xs
end

function test_newton_raphson()
    f(x) = [x[1]^2 + x[2]^2 - 4*x[3] - 0;
            x[1]^2 + x[3]^2 + 0*x[3] - (1/4);
            x[1]^2 + x[2]^2 + x[3]^2 - 1]
    x0 = [1.0, 1.0, 1.0]
    ϵ = 0.001
    x = newton_raphson(f, x0, ϵ)
    @info "Newton-Raphson iterations:"
    @info x
    @test isapprox(norm(f(x[end])), 0; atol=ϵ)
end
