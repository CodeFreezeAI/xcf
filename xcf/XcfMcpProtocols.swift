// XcfMcpProtocols.swift
// xcf
//
// Created by Todd Bruss on 5/17/25.
//

import MCP
import Foundation

/// Protocol for entities that provide MCP tools
protocol ToolMcpProvider {
    /// Get all tools provided by this entity
    var tools: [Tool] { get }
    
    /// Handle a tool call with the given parameters
    /// - Parameter params: The parameters for the tool call
    /// - Returns: The result of the tool call
    /// - Throws: Any errors that occur during tool execution
    func handleToolCall(_ params: CallTool.Parameters) async throws -> CallTool.Result
}

/// Protocol for entities that provide MCP resources
protocol ResourceProvider {
    /// Get all resources provided by this entity
    var resources: [Resource] { get }
    
    /// Handle a resource request with the given parameters
    /// - Parameter params: The parameters for the resource request
    /// - Returns: The result of the resource request
    /// - Throws: Any errors that occur during resource retrieval
    func handleResourceRequest(_ params: ReadResource.Parameters) async throws -> ReadResource.Result
}

/// Protocol for entities that provide MCP prompts
protocol PromptProvider {
    /// Get all prompts provided by this entity
    var prompts: [Prompt] { get }
    
    /// Handle a prompt request with the given parameters
    /// - Parameter params: The parameters for the prompt request
    /// - Returns: The result of the prompt request
    /// - Throws: Any errors that occur during prompt retrieval
    func handlePromptRequest(_ params: GetPrompt.Parameters) throws -> GetPrompt.Result
}

/// Protocol for entities that can register MCP handlers
protocol HandlerRegistrar {
    /// Register all handlers with the MCP server
    /// - Parameter server: The MCP server to register handlers with
    func registerHandlers(server: Server) async
} 
