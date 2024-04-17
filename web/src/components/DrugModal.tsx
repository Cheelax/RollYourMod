// DrugModal.tsx
import React from 'react';
import {
  Modal,
  ModalOverlay,
  ModalContent,
  ModalHeader,
  ModalCloseButton,
  ModalBody,
  ModalFooter,
  Button,
  NumberInput,
  NumberInputField,
  NumberInputStepper,
  NumberIncrementStepper,
  NumberDecrementStepper,
  Box,
  Icon
} from '@chakra-ui/react';

// Define a type for drug information
interface Drug {
  id: number;
  name: string;
  icon: typeof Icon; // Using IconType for custom icons that are React components
  quantity: number;
}

// Define props for the DrugModal component
interface DrugModalProps {
  isOpen: boolean;
  onClose: () => void;
  drugs: Drug[];
  handleQuantityChange: (valueAsString: string, valueAsNumber: number, id: number) => void;
}

export const DrugModal: React.FC<DrugModalProps> = ({ isOpen, onClose, drugs, handleQuantityChange }) => {
  return (
    <Modal isOpen={isOpen} onClose={onClose} isCentered>
      <ModalOverlay />
      <ModalContent>
        <ModalHeader>Choose Your Dosage</ModalHeader>
        <ModalCloseButton />
        <ModalBody>
          {drugs.map((drug) => (
            <Box key={drug.id} p={2} display="flex" alignItems="center">
              <drug.icon />
              <NumberInput
                size="sm"
                defaultValue={0}
                min={0}
                max={10}
                onChange={(valueAsString, valueAsNumber) => handleQuantityChange(valueAsString, valueAsNumber, drug.id)}
              >
                <NumberInputField />
                <NumberInputStepper>
                  <NumberIncrementStepper />
                  <NumberDecrementStepper />
                </NumberInputStepper>
              </NumberInput>
            </Box>
          ))}
        </ModalBody>
        <ModalFooter>
          <Button colorScheme="blue" mr={3} onClick={onClose}>
            Close
          </Button>
          <Button variant="ghost" onClick={() => console.log(drugs)}>
            Confirm
          </Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  );
};
