function controlinvestment_autodiff(args...; n::Int=200, type::Val{T}=Val(Float64), kwargs...) where T
  N = div(n, 2)
  h = 1/N
  x0 = 1.0
  gamma = 3
  function f(y)
    x, u = y[1:N], y[N+1:end]
    return 0.5 * h * sum((u[k] - 1) * x[k] + (u[k+1] - 1) * x[k+1] for k = 1 : N-1)
  end
  function c(y)
    x, u = y[1:N], y[N+1:end]
    return [x[k+1] - x[k] - 0.5 * h * gamma * (u[k] * x[k] + u[k+1] * x[k+1]) for k = 1 : N-1]
  end
  lvar = vcat(x0, -Inf*ones(T, N-1), zeros(T, N))
  uvar = vcat(x0, Inf*ones(T, N-1), ones(T, N))
  xi = vcat(ones(T, N), zeros(T, N))
  return ADNLPModel(f, xi, lvar, uvar, c, zeros(T, N-1), zeros(T, N-1), name="controlinvestment_autodiff")
end