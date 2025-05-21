<?php

namespace App\Http\Controllers;

use App\Models\Movie;
use Illuminate\Http\Request;

class MovieController extends Controller
{
    public function index()
    {
        $movies = Movie::orderBy('title')->get();
        return view('movies.index', compact('movies'));
    }

    public function create()
    {
        return view('movies.create');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'director' => 'required|string|max:255',
            'release_year' => 'required|integer|min:1800|max:' . (date('Y') + 5),
            'genre' => 'required|string|max:100',
            'synopsis' => 'nullable|string',
            'youtube_link' => 'nullable|url|max:255', // Agrega la validación para el enlace de YouTube
        ]);

        Movie::create($validated);

        return redirect()->route('movies.index')->with('success', 'Película creada exitosamente.');
    }

    public function show(Movie $movie)
    {
        return view('movies.show', compact('movie'));
    }

    public function edit(Movie $movie)
    {
        return view('movies.edit', compact('movie'));
    }

    public function update(Request $request, Movie $movie)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'director' => 'required|string|max:255',
            'release_year' => 'required|integer|min:1800|max:' . (date('Y') + 5),
            'genre' => 'required|string|max:100',
            'synopsis' => 'nullable|string',
            'youtube_link' => 'nullable|url|max:255', // Agrega la validación para el enlace de YouTube

        ]);

        $movie->update($validated);

        return redirect()->route('movies.index')->with('success', 'Película actualizada exitosamente.');
    }

    public function destroy(Movie $movie)
    {
        $movie->delete();
        return redirect()->route('movies.index')->with('success', 'Película eliminada exitosamente.');
    }
}
