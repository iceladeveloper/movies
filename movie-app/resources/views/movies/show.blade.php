@extends('layouts.app')

@section('title', $movie->title)

@section('content')
    <h1>{{ $movie->title }}</h1>
    <div class="card">
        <div class="card-body">
            <h5 class="card-title">Director: {{ $movie->director }}</h5>
            <p class="card-text"><strong>Año:</strong> {{ $movie->release_year }}</p>
            <p class="card-text"><strong>Género:</strong> {{ $movie->genre }}</p>
            <p class="card-text"><strong>Sinopsis:</strong> {{ $movie->synopsis ?: 'No disponible' }}</p>
        </div>
    </div>
    <a href="{{ route('movies.index') }}" class="btn btn-primary mt-3">Volver al listado</a>
    <a href="{{ route('movies.edit', $movie) }}" class="btn btn-warning mt-3">Editar</a>
@endsection