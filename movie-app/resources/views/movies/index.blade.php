@extends('layouts.app')

@section('title', 'Lista de Películas')

@section('content')
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h1>Películas</h1>
        <a href="{{ route('movies.create') }}" class="btn btn-primary">Añadir Película</a>
    </div>

    <table class="table table-striped">
        <thead>
            <tr>
                <th>ID</th>
                <th>Título</th>
                <th>Director</th>
                <th>Año</th>
                <th>Género</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            @forelse ($movies as $movie)
                <tr>
                    <td>{{ $movie->id }}</td>
                    <td>{{ $movie->title }}</td>
                    <td>{{ $movie->director }}</td>
                    <td>{{ $movie->release_year }}</td>
                    <td>{{ $movie->genre }}</td>
                    <td>
                        <a href="{{ route('movies.show', $movie) }}" class="btn btn-sm btn-info">Ver</a>
                        <a href="{{ route('movies.edit', $movie) }}" class="btn btn-sm btn-warning">Editar</a>
                        <form action="{{ route('movies.destroy', $movie) }}" method="POST" style="display:inline-block;">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('¿Estás seguro?')">Eliminar</button>
                        </form>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="6" class="text-center">No hay películas registradas.</td>
                </tr>
            @endforelse
        </tbody>
    </table>
@endsection