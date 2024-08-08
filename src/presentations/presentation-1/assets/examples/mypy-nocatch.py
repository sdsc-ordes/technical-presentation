def concatenate_elements(elements: list[int | str]) -> str:
    result = ""
    for element in elements:
        result += str(element)
    return result


# Example usage
mixed_elements: list[int | str] = [
    1,
    2,
    "asdf",
]  # This is fine as it conforms to List[Union[int, str]]
print(concatenate_elements(mixed_elements))  # Outputs: "12three"

# Dynamic alteration of list content
mixed_elements.append(None)
