<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureUserHasRole
{
    /**
     * Pastikan user yang login memiliki salah satu role yang diizinkan.
     *
     * Contoh penggunaan di route: ->middleware('role:customer')
     * atau ->middleware('role:mitra')
     */
    public function handle(Request $request, Closure $next, string ...$roles): Response
    {
        $user = $request->user();

        if (! $user || ! in_array($user->role, $roles, true)) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak. Role Anda tidak memiliki izin untuk endpoint ini.',
            ], 403);
        }

        return $next($request);
    }
}