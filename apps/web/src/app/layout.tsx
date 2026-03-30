import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'TOMASA - Moda Agro',
  description: 'E-commerce de moda agro para Brasil e Uruguai',
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
