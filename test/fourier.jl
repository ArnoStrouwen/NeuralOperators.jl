@testset "1D SpectralConv" begin
    modes = (16, )
    ch = 64 => 128

    m = Chain(
        Dense(2, 64),
        SpectralConv(ch, modes)
    )
    @test ndims(SpectralConv(ch, modes)) == 1
    @test repr(SpectralConv(ch, modes)) == "SpectralConv(64 => 128, (16,), σ=identity)"

    𝐱, _ = get_burgers_data(n=5)
    @test size(m(𝐱)) == (128, 1024, 5)

    loss(x, y) = Flux.mse(m(x), y)
    data = [(𝐱, rand(Float32, 128, 1024, 5))]
    Flux.train!(loss, params(m), data, Flux.ADAM())
end

@testset "permuted 1D SpectralConv" begin
    modes = (16, )
    ch = 64 => 128

    m = Chain(
        Conv((1, ), 2=>64),
        SpectralConv(ch, modes, permuted=true)
    )
    @test ndims(SpectralConv(ch, modes, permuted=true)) == 1

    𝐱, _ = get_burgers_data(n=5)
    𝐱 = permutedims(𝐱, (2, 1, 3))
    @test size(m(𝐱)) == (1024, 128, 5)

    loss(x, y) = Flux.mse(m(x), y)
    data = [(𝐱, rand(Float32, 1024, 128, 5))]
    Flux.train!(loss, params(m), data, Flux.ADAM())
end

@testset "1D FourierOperator" begin
    modes = (16, )
    ch = 64 => 128

    m = Chain(
        Dense(2, 64),
        FourierOperator(ch, modes)
    )

    𝐱, _ = get_burgers_data(n=5)
    @test size(m(𝐱)) == (128, 1024, 5)

    loss(x, y) = Flux.mse(m(x), y)
    data = [(𝐱, rand(Float32, 128, 1024, 5))]
    Flux.train!(loss, params(m), data, Flux.ADAM())
end

@testset "permuted 1D FourierOperator" begin
    modes = (16, )
    ch = 64 => 128

    m = Chain(
        Conv((1, ), 2=>64),
        FourierOperator(ch, modes, permuted=true)
    )

    𝐱, _ = get_burgers_data(n=5)
    𝐱 = permutedims(𝐱, (2, 1, 3))
    @test size(m(𝐱)) == (1024, 128, 5)

    loss(x, y) = Flux.mse(m(x), y)
    data = [(𝐱, rand(Float32, 1024, 128, 5))]
    Flux.train!(loss, params(m), data, Flux.ADAM())
end

@testset "2D SpectralConv" begin
    modes = (16, 16)
    ch = 64 => 64

    m = Chain(
        Dense(1, 64),
        SpectralConv(ch, modes)
    )
    @test ndims(SpectralConv(ch, modes)) == 2

    𝐱, _, _, _ = get_darcy_flow_data(n=5, Δsamples=20)
    @test size(m(𝐱)) == (64, 22, 22, 5)

    loss(x, y) = Flux.mse(m(x), y)
    data = [(𝐱, rand(Float32, 64, 22, 22, 5))]
    Flux.train!(loss, params(m), data, Flux.ADAM())
end

@testset "permuted 2D SpectralConv" begin
    modes = (16, 16)
    ch = 64 => 64

    m = Chain(
        Conv((1, 1), 1=>64),
        SpectralConv(ch, modes, permuted=true)
    )
    @test ndims(SpectralConv(ch, modes, permuted=true)) == 2

    𝐱, _, _, _ = get_darcy_flow_data(n=5, Δsamples=20)
    𝐱 = permutedims(𝐱, (2, 3, 1, 4))
    @test size(m(𝐱)) == (22, 22, 64, 5)

    loss(x, y) = Flux.mse(m(x), y)
    data = [(𝐱, rand(Float32, 22, 22, 64, 5))]
    Flux.train!(loss, params(m), data, Flux.ADAM())
end

@testset "2D FourierOperator" begin
    modes = (16, 16)
    ch = 64 => 64

    m = Chain(
        Dense(1, 64),
        FourierOperator(ch, modes)
    )

    𝐱, _, _, _ = get_darcy_flow_data(n=5, Δsamples=20)
    @test size(m(𝐱)) == (64, 22, 22, 5)

    loss(x, y) = Flux.mse(m(x), y)
    data = [(𝐱, rand(Float32, 64, 22, 22, 5))]
    Flux.train!(loss, params(m), data, Flux.ADAM())
end

@testset "permuted 2D FourierOperator" begin
    modes = (16, 16)
    ch = 64 => 64

    m = Chain(
        Conv((1, 1), 1=>64),
        FourierOperator(ch, modes, permuted=true)
    )

    𝐱, _, _, _ = get_darcy_flow_data(n=5, Δsamples=20)
    𝐱 = permutedims(𝐱, (2, 3, 1, 4))
    @test size(m(𝐱)) == (22, 22, 64, 5)

    loss(x, y) = Flux.mse(m(x), y)
    data = [(𝐱, rand(Float32, 22, 22, 64, 5))]
    Flux.train!(loss, params(m), data, Flux.ADAM())
end
