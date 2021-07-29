require 'pry'
require 'json'

class Application
    def call(env)
        resp = Rack::Response.new
        req = Rack::Request.new(env)

        if req.path.match(/tasks/) && req.get?
            tasks = Task.all.map do |task|
                {
                    id: task.id,
                    text: task.text,
                    category: task.category.name
                }
            end
            return [200, { 'Content-Type' => 'application/json' }, [{tasks: tasks, message: 'response success' }.to_json]]
        elsif req.path.match(/tasks/) && req.post?

            task = JSON.parse(req.body.read)
            cat = Category.find_by(name: task["category"])
            task = cat.tasks.build(text: task["text"])

            if task.save
                return [200, { 'Content-Type' => 'application/json' }, [{task: {text: task.text, category: task.category.name, id: task.id}, message: 'task successfully created' }.to_json]]
            else
                return [422, { 'Content-Type' => 'application/json' }, [{error: 'failed to create'}.to_json]]
            end
        
        elsif req.path.match(/tasks/) && req.delete?

            id = req.path.split("/tasks/").last.to_i
            task = Task.find_by_id(id)

            if task.destroy
                return [200, { 'Content-Type' => 'application/json' }, [{task: {text: task.text, category: task.category.name, id: task.id}, message: 'task successfully deleted' }.to_json]]
            else
                return [422, { 'Content-Type' => 'application/json' }, [{error: 'unable to delete task'}.to_json]]
            end

        else
            resp.write 'Path Not Found'

        end

        resp.finish
    end
end
