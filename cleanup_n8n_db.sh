#!/bin/bash
# Archivo: cleanup_n8n_db.sh

echo "🧹 Iniciando limpieza de base de datos n8n..."

# Mostrar estadísticas antes
echo "📊 Estadísticas antes de la limpieza:"
docker-compose exec postgres psql -U n8n_user -d n8n_database -c "
SELECT 
    'Ejecuciones totales' as metric, 
    COUNT(*) as count 
FROM execution_entity
UNION ALL
SELECT 
    'Ejecuciones últimos 7 días', 
    COUNT(*) 
FROM execution_entity 
WHERE execution_entity.startedAt > NOW() - INTERVAL '7 days';"

# Eliminar ejecuciones antiguas
echo "🗑️  Eliminando ejecuciones antiguas..."
docker-compose exec postgres psql -U n8n_user -d n8n_database -c "
DELETE FROM execution_entity 
WHERE execution_entity.startedAt < NOW() - INTERVAL '7 days';"

# Vacuum y analyze
echo "🔧 Ejecutando mantenimiento de base de datos..."
docker-compose exec postgres psql -U n8n_user -d n8n_database -c "
VACUUM ANALYZE execution_entity;
VACUUM ANALYZE workflow_entity;
SELECT pg_stat_reset();"

# Mostrar estadísticas después
echo "✅ Estadísticas después de la limpieza:"
docker-compose exec postgres psql -U n8n_user -d n8n_database -c "
SELECT 
    tablename,
    pg_size_pretty(pg_total_relation_size('public.'||tablename)) as size
FROM pg_tables 
WHERE schemaname = 'public' 
ORDER BY pg_total_relation_size('public.'||tablename) DESC;"

echo "🎉 Limpieza completada!"
