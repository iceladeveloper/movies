<div class="mb-3">
    <label for="title" class="form-label">Título</label>
    <input type="text" class="form-control" id="title" name="title" value="{{ old('title', $movie->title ?? '') }}" required>
</div>
<div class="mb-3">
    <label for="director" class="form-label">Director</label>
    <input type="text" class="form-control" id="director" name="director" value="{{ old('director', $movie->director ?? '') }}" required>
</div>
<div class="mb-3">
    <label for="release_year" class="form-label">Año de Lanzamiento</label>
    <input type="number" class="form-control" id="release_year" name="release_year" value="{{ old('release_year', $movie->release_year ?? '') }}" required min="1800" max="{{ date('Y') + 5 }}">
</div>
<div class="mb-3">
    <label for="genre" class="form-label">Género</label>
    <input type="text" class="form-control" id="genre" name="genre" value="{{ old('genre', $movie->genre ?? '') }}" required>
</div>
<div class="mb-3">
    <label for="synopsis" class="form-label">Sinopsis</label>
    <textarea class="form-control" id="synopsis" name="synopsis" rows="3">{{ old('synopsis', $movie->synopsis ?? '') }}</textarea>
</div>
<button type="submit" class="btn btn-success">{{ $buttonText ?? 'Guardar' }}</button>
<a href="{{ route('movies.index') }}" class="btn btn-secondary">Cancelar</a>