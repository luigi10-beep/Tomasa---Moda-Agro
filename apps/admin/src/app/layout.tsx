import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'TOMASA Admin',
  description: 'Painel administrativo TOMASA',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="pt-BR">
      <body>{children}</body>
    </html>
  )
}
