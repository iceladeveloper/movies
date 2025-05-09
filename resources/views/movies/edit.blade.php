@extends('layouts.app')

@section('title', 'Editar Película')

@section('content')
    <h1>Editar Película: {{ $movie->title }}</h1>
    <form action="{{ route('movies.update', $movie) }}" method="POST">
        @csrf
        @method('PUT')
        @include('movies._form', ['buttonText' => 'Actualizar Película'])
    </form>
@endsection