/**
 * TOMASA Workers API
 * Backend serverless para e-commerce multi-regional
 */

export interface Env {
  // D1 Database binding
  db_binding: D1Database
  
  // R2 Storage binding
  r2_binding: R2Bucket
  
  // Environment variables
  REGION: string
  R2_PUBLIC_URL: string
}

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    const url = new URL(request.url)
    
    // Health check
    if (url.pathname === '/health') {
      return new Response(JSON.stringify({ status: 'ok', timestamp: new Date().toISOString() }), {
        headers: { 'Content-Type': 'application/json' },
      })
    }
    
    // Default response
    return new Response('TOMASA Workers API - Em construção', {
      headers: { 'Content-Type': 'text/plain' },
    })
  },
}
