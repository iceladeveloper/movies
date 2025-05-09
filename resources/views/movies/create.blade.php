@extends('layouts.app')

@section('title', 'Añadir Película')

@section('content')
    <h1>Añadir Nueva Película</h1>
    <form action="{{ route('movies.store') }}" method="POST">
        @csrf
        @include('movies._form', ['buttonText' => 'Crear Película'])
    </form>
@endsection