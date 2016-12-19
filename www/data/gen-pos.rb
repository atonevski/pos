require 'sqlite3'
require 'json'

# DB dsales
DB = File.expand_path('/home/and/Scripts/Ruby/dsales/db/dsales.db')
db = SQLite3::Database.new DB
db.execute('PRAGMA foreign_keys=ON');
unless 1 == db.get_first_value('PRAGMA foreign_keys').to_i
  raise "Can't set foreign keys pragma!" 
end
db.results_as_hash = true

qry =<<-EOS
  SELECT
     t.id         AS id,
     t.name       AS name,
     a.id         AS agent_id,
     a.name       AS agent_name,
     t.city       AS city,
     ti.address   AS address,
     ti.tel       AS tel,
     ti.lat       AS latitude,
     ti.lng       AS longitude
  FROM
    terminals AS t
    INNER JOIN terminfo AS ti
      ON t.id = ti.id
    INNER JOIN agents AS a
      ON a.id = t.agent_id
  WHERE
    t.id IN (
      SELECT
        DISTINCT s.terminal_id AS id
      FROM
        sales AS s
      WHERE
        s.date BETWEEN date('now', '-6 months') AND date('now', '-1 day')
      ORDER BY id
    )
    AND (ti.lat IS NOT NULL AND ti.lng IS NOT NULL)
EOS

res = db.execute(qry)
res.each { |r| print "#{ r['id'] } " }
puts
puts "total: #{ res.length }"
puts
json_res  = res.map do |r|
              {
                id:         r['id'],
                name:       r['name'],
                agent_id:   r['agent_id'],
                agent_name: r['agent_name'],
                city:       r['city'],
                address:    r['address'],
                telephone:  r['tel'],
                latitude:   r['latitude'],
                longitude:  r['longitude']
              }
            end
File.open('pos.json', 'w') { |f| f.write JSON.pretty_generate json_res }
puts "total: #{ json_res.length }"

