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
            @if ($movie->youtube_link)
              <div class="mb-3">
                <strong>Enlace de YouTube:</strong>
               @php
                 $videoId = '';
                 $parsedUrl = parse_url($movie->youtube_link);
                 if ($parsedUrl && isset($parsedUrl['query'])) {
                    parse_str($parsedUrl['query'], $queryParams);
                    if (isset($queryParams['v'])) {
                        $videoId = $queryParams['v'];
                    } elseif (isset($parsedUrl['path'])) {
                        $pathParts = explode('/', trim($parsedUrl['path'], '/'));
                        if (count($pathParts) > 0) {
                            $videoId = end($pathParts);
                        }
                    }
              } elseif ($parsedUrl && isset($parsedUrl['path'])) {
                    $pathParts = explode('/', trim($parsedUrl['path'], '/'));
                    if (count($pathParts) > 1 && $pathParts[count($pathParts) - 2] === 'embed') {
                        $videoId = end($pathParts);
                    }
                }
            @endphp

            @if ($videoId)
                <div class="ratio ratio-16x9">
                    <iframe src="https://www.youtube.com/embed/{{ $videoId }}"
                            title="YouTube video player"
                            frameborder="0"
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                            allowfullscreen></iframe>
                </div>
            @else
                <p>Enlace de YouTube no válido.</p>
            @endif
        </div>
    @endif

               </div>
        </div>
    </div>
    <a href="{{ route('movies.index') }}" class="btn btn-primary mt-3">Volver al listado</a>
    <a href="{{ route('movies.edit', $movie) }}" class="btn btn-warning mt-3">Editar</a>
@endsection